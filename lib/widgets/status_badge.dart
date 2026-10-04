import 'package:flutter/material.dart';
import '../models/court.dart';
import 'sport_style.dart';

class SportBadge extends StatelessWidget {
  final Sport sport;

  const SportBadge(this.sport, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sport.icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            sport.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}