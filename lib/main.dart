import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() => runApp(const SportsCourtApp());

class SportsCourtApp extends StatelessWidget {
  const SportsCourtApp({super.key});

  @override
  Widget build(BuildContext context) {
    // palette is derived from one seed color
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1B8F55));

    return MaterialApp(
      title: 'SportsCourt',
      debugShowCheckedModeBanner: false,
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
      home: const LoginScreen(),
    );
  }
}