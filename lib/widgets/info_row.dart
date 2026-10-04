import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final bool emphasized;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
          ],
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: emphasized
                  ? theme.textTheme.titleLarge?.copyWith(color: scheme.primary)
                  : theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}