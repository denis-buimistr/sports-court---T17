import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/booking.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/section_title.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

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
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          return switch (item) {
            Booking b => BookingCard(booking: b),
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