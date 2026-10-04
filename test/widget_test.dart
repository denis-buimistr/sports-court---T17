import 'package:flutter_test/flutter_test.dart';
import 'package:sports_court_frontend/main.dart';

void main() {
  testWidgets('Стартовый экран — вход', (tester) async {
    await tester.pumpWidget(const SportsCourtApp());

    expect(find.text('Войти'), findsOneWidget);
  });
}