import 'package:flutter/material.dart';

class AmenityChip extends StatelessWidget {
  final String label;

  const AmenityChip(this.label, {super.key});

  // icon picked by keyword
  IconData get _icon {
    final l = label.toLowerCase();
    if (l.contains('крыт')) return Icons.home_outlined;
    if (l.contains('газон')) return Icons.grass;
    if (l.contains('освещ')) return Icons.lightbulb_outline;
    if (l.contains('раздевал')) return Icons.checkroom_outlined;
    if (l.contains('душ')) return Icons.shower_outlined;
    if (l.contains('трибун')) return Icons.event_seat_outlined;
    if (l.contains('ракет') || l.contains('корт')) return Icons.sports_tennis;
    if (l.contains('тренер')) return Icons.person_outline;
    if (l.contains('кондиц')) return Icons.ac_unit;
    if (l.contains('паркет')) return Icons.grid_view;
    if (l.contains('табло')) return Icons.timer_outlined;
    if (l.contains('парков')) return Icons.local_parking;
    if (l.contains('песч')) return Icons.beach_access_outlined;
    if (l.contains('мяч')) return Icons.sports_volleyball;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}