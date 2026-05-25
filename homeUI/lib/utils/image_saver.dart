import 'dart:typed_data';

import 'image_saver_stub.dart'
    if (dart.library.html) 'image_saver_web.dart'
    if (dart.library.io) 'image_saver_io.dart';

/// 플랫폼에 맞게 영수증 이미지를 저장합니다.
/// 반환값: 저장 경로 또는 파일명 (웹은 다운로드 파일명)
Future<String> saveReceiptImage(Uint8List bytes) => platformSaveReceiptImage(bytes);
