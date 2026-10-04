import 'package:flutter/material.dart';
import '../models/booking.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (bg, fg, icon) = switch (status) {
      BookingStatus.confirmed => (
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
          Icons.check_circle_outline,
        ),
      BookingStatus.completed => (
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
          Icons.history,
        ),
      BookingStatus.cancelled => (
          scheme.errorContainer,
          scheme.onErrorContainer,
          Icons.cancel_outlined,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}