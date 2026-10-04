// lib/screens/my_bookings/my_bookings_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widgets/status_badge.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = MockData.bookings;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои брони')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final b = bookings[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(b.court.name),
              subtitle: Text('${b.date} · ${b.startTime}–${b.endTime}'),
              trailing: StatusBadge(status: b.status),
            ),
          );
        },
      ),
    );
  }
}