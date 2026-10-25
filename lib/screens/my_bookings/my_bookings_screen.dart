import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../models/bookings_model.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/section_title.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  // the L3 dialog finally gets its effect
  Future<void> _cancel(BuildContext context, Booking booking) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Отменить бронь?'),
        content: Text(
          '${booking.court.name}, ${booking.slot.date} '
          'в ${booking.slot.startTime}. Слот снова станет свободным.',
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

    if (ok != true || !context.mounted) return;

    final error = await context.read<BookingsModel>().cancel(booking.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(error ?? 'Бронь отменена: ${booking.court.name}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BookingsModel>();

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!,
        onRetry: () => context.read<BookingsModel>().load(),
      );
    } else {
      final upcoming = model.upcoming;
      final past = model.past;

      // flat list: String = section header, Booking = card
      final items = <Object>[
        'Предстоящие',
        ...upcoming,
        'Прошедшие',
        ...past,
      ];

      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          return switch (item) {
            Booking b => BookingCard(
                key: ValueKey(b.id), // identity from the data
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои брони'),
        actions: [
          IconButton(
            onPressed: () => context.read<BookingsModel>().load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: body,
    );
  }
}