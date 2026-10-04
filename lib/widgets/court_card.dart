import 'package:flutter/material.dart';
import '../models/court.dart';
import 'amenity_chip.dart';
import 'app_card.dart';
import 'court_photo.dart';
import 'sport_badge.dart';

class CourtCard extends StatelessWidget {
  final Court court;
  final VoidCallback? onTap;

  const CourtCard({super.key, required this.court, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CourtPhoto(court: court, height: 150),
              Positioned(left: 12, top: 12, child: SportBadge(court.sport)),
              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: scheme.surface,
                  child: Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: court.pricePerHour.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' MDL / час',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  court.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${court.address}, ${court.district}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final a in court.amenities.take(3)) AmenityChip(a),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}