import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/bookings_model.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.sports_soccer_outlined),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Площадки',
          ),
          // one live corner: Consumer rebuilds only the badge
          NavigationDestination(
            icon: Consumer<BookingsModel>(
              builder: (context, bookings, child) => Badge(
                isLabelVisible: bookings.upcomingCount > 0,
                label: Text('${bookings.upcomingCount}'),
                child: child,
              ),
              child: const Icon(Icons.event_note_outlined),
            ),
            selectedIcon: Consumer<BookingsModel>(
              builder: (context, bookings, child) => Badge(
                isLabelVisible: bookings.upcomingCount > 0,
                label: Text('${bookings.upcomingCount}'),
                child: child,
              ),
              child: const Icon(Icons.event_note),
            ),
            label: 'Мои брони',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}