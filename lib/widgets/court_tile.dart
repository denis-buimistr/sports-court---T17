import 'package:flutter/material.dart';
import '../models/court.dart';
import 'court_photo.dart';

class CourtTile extends StatelessWidget {
  final Court court;
  final Widget? trailing;

  const CourtTile({super.key, required this.court, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final end = trailing;

    return Row(
      children: [
        SizedBox(
          width: 72,
          child: CourtPhoto(court: court, height: 72, radius: 16),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                court.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '${court.sport.label}, ${court.district}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                court.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        if (end != null) ...[
          const SizedBox(width: 8),
          end,
        ],
      ],
    );
  }
}