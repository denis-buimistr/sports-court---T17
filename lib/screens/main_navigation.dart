// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'courts/courts_list_screen.dart';
import 'my_bookings/my_bookings_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  static const _screens = [
    CourtsListScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_soccer_outlined), label: 'Площадки'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), label: 'Мои брони'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
    );
  }
}