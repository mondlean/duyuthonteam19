import 'package:flutter_test/flutter_test.dart';

import 'package:home_ui/main.dart';

void main() {
  testWidgets('Onboarding screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const DuyuApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('성장을 시작하세요'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}
