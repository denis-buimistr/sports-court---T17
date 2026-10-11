import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/booking.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/section_title.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  // destructive action: ask first
  Future<void> _cancel(BuildContext context, Booking booking) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Отменить бронь?'),
        content: Text(
          '${booking.court.name}, ${booking.slot.date} '
          'в ${booking.slot.startTime}. Отмена бесплатна за 24 часа до начала.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Да, отменить'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Бронь отменена: ${booking.court.name}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = MockData.bookings.where((b) => b.isUpcoming).toList();
    final past = MockData.bookings.where((b) => !b.isUpcoming).toList();

    // flat list: String = section header, Booking = card
    final items = <Object>[
      'Предстоящие',
      ...upcoming,
      'Прошедшие',
      ...past,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Мои брони')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          return switch (item) {
            Booking b => BookingCard(
                booking: b,
                onCancel: b.isUpcoming ? () => _cancel(context, b) : null,
              ),
            String title => Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                child: SectionTitle(
                  title,
                  trailing: '${title == 'Предстоящие' ? upcoming.length : past.length}',
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}