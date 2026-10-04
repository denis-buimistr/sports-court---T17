import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  final String caption;
  final String value;
  final String buttonLabel;
  final VoidCallback onPressed;

  const BottomActionBar({
    super.key,
    required this.caption,
    required this.value,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    caption,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  Text(value, style: theme.textTheme.titleLarge),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}