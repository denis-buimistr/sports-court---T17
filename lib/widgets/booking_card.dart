import 'package:flutter/material.dart';
import '../models/booking.dart';
import 'app_card.dart';
import 'court_tile.dart';
import 'status_badge.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final slot = booking.slot;

    // action depends on status
    final Widget? action = switch (booking.status) {
      BookingStatus.confirmed => TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.close, size: 18),
          label: const Text('Отменить бронь'),
          style: TextButton.styleFrom(foregroundColor: scheme.error),
        ),
      BookingStatus.completed => TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.replay, size: 18),
          label: const Text('Забронировать снова'),
        ),
      BookingStatus.cancelled => null,
    };

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourtTile(court: booking.court),
          const Divider(height: 28),
          Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              _Meta(icon: Icons.calendar_today_outlined, text: slot.date),
              _Meta(icon: Icons.schedule, text: '${slot.startTime} – ${slot.endTime}'),
              _Meta(
                icon: Icons.payments_outlined,
                text: '${booking.totalPrice.toStringAsFixed(0)} MDL',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              StatusBadge(status: booking.status),
              const Spacer(),
              if (action != null) action,
            ],
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}