import 'package:flutter/foundation.dart';

class Globals {
  static String? loginId;

  /// Spring Boot: 8080, FastAPI: 8000
  static String get _host {
    if (kIsWeb) return 'http://127.0.0.1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2';
    }
    return 'http://127.0.0.1';
  }

  static String get springBaseUrl => '$_host:8080';
  static String get plantBaseUrl => '$_host:8000';
}
