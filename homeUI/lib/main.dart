import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF9F9FC),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const DuyuApp());
}

class DuyuApp extends StatelessWidget {
  const DuyuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '초록수증',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: buildRouter(),
    );
  }
}
