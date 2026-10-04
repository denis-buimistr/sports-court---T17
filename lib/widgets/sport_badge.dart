import 'package:flutter/material.dart';
import '../models/court.dart';
import 'sport_style.dart';

class SportBadge extends StatelessWidget {
  final Sport sport;

  const SportBadge(this.sport, {super.key});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = sport.colors(Theme.of(context).colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(sport.icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            sport.label,
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
