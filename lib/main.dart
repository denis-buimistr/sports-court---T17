import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/auth_api.dart';
import 'data/booking_repository.dart';
import 'data/court_repository.dart';
import 'data/mock_booking_repository.dart';
import 'data/mock_court_repository.dart';
import 'data/mock_store.dart';
import 'data/token_store.dart';
import 'models/bookings_model.dart';
import 'models/courts_model.dart';
import 'models/slots_model.dart';
import 'router.dart';

// the Android emulator does not know "localhost": the laptop is 10.0.2.2;
// iOS simulator / desktop / web reach the server at localhost.
// On a real phone: put the laptop's IP in the local network here.
final String apiBase =
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080'
        : 'http://localhost:8080';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // prefs before runApp (C9)

  final tokens = TokenStore();
  final loggedIn = await tokens.read() != null; // the start is decided by the token

  router = GoRouter(
    initialLocation: loggedIn ? '/courts' : '/login',
    routes: appRoutes, // L3 routes, unchanged
  );

  // composition root: the data source is chosen HERE and only here
  final store = MockStore();
  final CourtRepository courtRepository = MockCourtRepository(store);
  final BookingRepository bookingRepository = MockBookingRepository(store);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthApi>(create: (_) => AuthApi(apiBase, tokens)),
        // failure-switch scaffolding (task 7) — disappears on L5
        Provider<MockStore>.value(value: store),
        ChangeNotifierProvider(create: (_) => CourtsModel(courtRepository)..load()),
        ChangeNotifierProvider(create: (_) => BookingsModel(bookingRepository)..load()),
        ChangeNotifierProvider(create: (_) => SlotsModel(courtRepository)),
      ],
      child: const SportsCourtApp(),
    ),
  );
}

class SportsCourtApp extends StatelessWidget {
  const SportsCourtApp({super.key});

  @override
  Widget build(BuildContext context) {
    // palette is derived from one seed color
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1B8F55));

    return MaterialApp.router(
      title: 'SportsCourt',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: scheme,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
          headlineSmall: TextStyle(fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: scheme.surfaceContainer,
          indicatorColor: scheme.primaryContainer,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(64, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}