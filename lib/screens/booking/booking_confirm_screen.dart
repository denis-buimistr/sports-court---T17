// lib/screens/booking/booking_confirm_screen.dart
import 'package:flutter/material.dart';
import '../../models/court.dart';
import '../../models/time_slot.dart';
import '../../models/booking.dart';
import '../../widgets/status_badge.dart';
import '../main_navigation.dart';

class BookingConfirmScreen extends StatelessWidget {
  final Court court;
  final TimeSlot slot;

  const BookingConfirmScreen({super.key, required this.court, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подтверждение брони')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(court.name, style: Theme.of(context).textTheme.titleMedium),
                        const StatusBadge(status: BookingStatus.confirmed),
                      ],
                    ),
                    const Divider(height: 24),
                    _infoRow('Дата', slot.date),
                    _infoRow('Время', '${slot.startTime} – ${slot.endTime}'),
                    _infoRow('Адрес', court.address),
                    const Divider(height: 24),
                    _infoRow(
                      'Итого',
                      '${court.pricePerHour.toStringAsFixed(0)} MDL',
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigation()),
                (route) => false,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Готово'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}