import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareWidgetAsImage({
    required GlobalKey boundaryKey,
    required String fileName,
    String? text,
    String? subject,
  }) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // pixelRatio 3.0 → 2.0: 메모리 사용량 9x → 4x로 감소 (화질 차이 미미)
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      // PNG 인코딩된 바이트를 isolate에서 파일로 기록 (메인 스레드 잰크 방지)
      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName.png';
      await compute(_writeFile, _WriteFileParams(filePath, buffer));

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          text: text,
          subject: subject,
        ),
      );
    } catch (e) {
      debugPrint('Error sharing widget: $e');
    }
  }
}

class _WriteFileParams {
  final String path;
  final Uint8List bytes;
  const _WriteFileParams(this.path, this.bytes);
}

Future<void> _writeFile(_WriteFileParams params) async {
  await File(params.path).writeAsBytes(params.bytes);
}
