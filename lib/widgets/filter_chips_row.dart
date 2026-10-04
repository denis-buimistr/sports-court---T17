import 'package:flutter/material.dart';

class FilterOption {
  final String label;
  final IconData? icon;

  const FilterOption(this.label, {this.icon});
}

// visual only, filters work from L4
class FilterChipsRow extends StatelessWidget {
  final List<FilterOption> options;
  final int selectedIndex;

  const FilterChipsRow({
    super.key,
    required this.options,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final icon = option.icon;

          return FilterChip(
            avatar: icon == null ? null : Icon(icon, size: 18),
            label: Text(option.label),
            selected: index == selectedIndex,
            showCheckmark: false,
            onSelected: (_) {},
          );
        },
      ),
    );
  }
}