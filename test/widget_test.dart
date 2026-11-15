import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sports_court_frontend/main.dart';
import 'package:sports_court_frontend/router.dart';

void main() {
  testWidgets('Стартовый экран — вход', (tester) async {
    // main() builds the router from the saved token; without a token -> /login
    router = GoRouter(initialLocation: '/login', routes: appRoutes);

    await tester.pumpWidget(const SportsCourtApp());
    await tester.pumpAndSettle();

    expect(find.text('Войти'), findsOneWidget);
  });
}
