import 'package:flutter/foundation.dart';

/// 오픈소스 라이선스 등록 유틸리티
/// 수동으로 추가한 에셋(폰트 등)의 라이선스를 Flutter LicenseRegistry에 등록합니다.
abstract final class LicenseRegistryUtil {
  static void init() {
    // 1. Noto Serif KR (SIL Open Font License 1.1)
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(
        ['Noto Serif KR'],
        '''
Copyright 2017 The Noto Project Authors (https://github.com/googlefonts/noto-cjk)

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
https://scripts.sil.org/OFL
''',
      );
    });

    // 2. Inter (SIL Open Font License 1.1)
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(
        ['Inter'],
        '''
Copyright (c) 2016-2024 The Inter Project Authors (https://github.com/rsms/inter)

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
https://scripts.sil.org/OFL
''',
      );
    });
  }
}
