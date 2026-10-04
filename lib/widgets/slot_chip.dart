import 'package:flutter/material.dart';

enum SlotState { available, selected, booked }

class SlotChip extends StatelessWidget {
  final String start;
  final String end;
  final SlotState state;

  const SlotChip({
    super.key,
    required this.start,
    required this.end,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (bg, fg, border) = switch (state) {
      SlotState.available => (scheme.surfaceContainerLow, scheme.onSurface, scheme.outlineVariant),
      SlotState.selected => (scheme.primary, scheme.onPrimary, scheme.primary),
      SlotState.booked => (scheme.surfaceContainerHighest, scheme.outline, scheme.surfaceContainerHighest),
    };
    final booked = state == SlotState.booked;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: state == SlotState.selected ? 2 : 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            start,
            style: TextStyle(
              color: fg,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              decoration: booked ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            booked ? 'занято' : 'до $end',
            style: TextStyle(color: fg, fontSize: 11),
          ),
        ],
      ),
    );
  }
}