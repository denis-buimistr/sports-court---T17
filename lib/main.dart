import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/booking_repository.dart';
import 'data/court_repository.dart';
import 'data/mock_booking_repository.dart';
import 'data/mock_court_repository.dart';
import 'data/mock_store.dart';
import 'models/bookings_model.dart';
import 'models/courts_model.dart';
import 'models/slots_model.dart';
import 'router.dart';

void main() {
  // composition root: the data source is chosen HERE and only here
  final store = MockStore();
  final CourtRepository courtRepository = MockCourtRepository(store);
  final BookingRepository bookingRepository = MockBookingRepository(store);

  runApp(
    MultiProvider(
      providers: [
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