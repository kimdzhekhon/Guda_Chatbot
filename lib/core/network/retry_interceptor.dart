import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Guda 재시도 인터셉터 — 지수 백오프 + 5xx 서버 에러 재시도
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
  });

  final Dio dio;
  final int maxRetries;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    var attempt = 0;

    if (_shouldRetry(err)) {
      while (attempt < maxRetries) {
        attempt++;
        // 지수 백오프: 1초, 2초, 4초 (+ 약간의 랜덤 지터)
        final baseDelay = Duration(milliseconds: (pow(2, attempt - 1) * 1000).toInt());
        final jitter = Duration(milliseconds: Random().nextInt(500));
        final delay = baseDelay + jitter;

        debugPrint('[Retry] 재시도 $attempt/$maxRetries (${delay.inMilliseconds}ms 후)');

        try {
          await Future.delayed(delay);
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          if (attempt >= maxRetries || !_shouldRetry(e)) {
            return handler.next(e);
          }
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // 타임아웃 또는 네트워크 연결 오류
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.error is SocketException) {
      return true;
    }
    // 5xx 서버 에러 (500, 502, 503, 504)
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return true;
    }
    return false;
  }
}
