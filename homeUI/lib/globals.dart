import 'package:flutter/foundation.dart';

class Globals {
  static String? loginId;

  /// eco_spring_login=8081, eco_spring_point=8080
  static String get _host {
    if (kIsWeb) return 'http://127.0.0.1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2';
    }
    return 'http://127.0.0.1';
  }

  static String get loginBaseUrl => '$_host:8081';
  static String get pointBaseUrl => '$_host:8080';
}
