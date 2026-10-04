// lib/screens/booking/time_slot_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/court.dart';
import '../../widgets/court_card.dart';
import 'booking_confirm_screen.dart';

class TimeSlotScreen extends StatelessWidget {
  final Court court;

  const TimeSlotScreen({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    final slots = MockData.timeSlotsForCourt(court.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Выбор времени')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CourtCard(court: court),
          const SizedBox(height: 20),
          Text('Свободные слоты — ${slots.first.date}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: slots.map((slot) {
              return FilterChip(
                label: Text(slot.startTime),
                selected: false,
                onSelected: slot.isAvailable ? (_) {} : null,
                backgroundColor: slot.isAvailable ? null : Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: slot.isAvailable ? null : Colors.grey,
                  decoration: slot.isAvailable ? null : TextDecoration.lineThrough,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingConfirmScreen(court: court, slot: slots.first),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Подтвердить бронь'),
            ),
          ),
        ],
      ),
    );
  }
}