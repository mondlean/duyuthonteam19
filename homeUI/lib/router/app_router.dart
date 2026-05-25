import 'dart:typed_data';

import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/plant_selection_screen.dart';
import '../screens/receipt_result_screen.dart';
import '../screens/receipt_scan_screen.dart';
import '../screens/receipt_scanning_screen.dart';
import '../screens/rewards_screen.dart';
import '../screens/signup_screen.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/plant-selection',
        builder: (_, __) => const PlantSelectionScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/scan',
        builder: (_, __) => const ReceiptScanScreen(),
      ),
      GoRoute(
        path: '/scan-loading',
        builder: (context, state) {
          final bytes = state.extra as Uint8List? ?? Uint8List(0);
          return ReceiptScanningScreen(imageBytes: bytes);
        },
      ),
      GoRoute(
        path: '/scan-result',
        builder: (_, __) => const ReceiptResultScreen(),
      ),
      GoRoute(
        path: '/rewards',
        builder: (_, __) => const RewardsScreen(),
      ),
    ],
  );
}
