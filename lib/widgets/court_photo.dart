import 'package:flutter/material.dart';
import '../models/court.dart';
import 'sport_style.dart';

// placeholder instead of a photo: gradient + sport icon
class CourtPhoto extends StatelessWidget {
  final Court court;
  final double height;
  final double radius;

  const CourtPhoto({
    super.key,
    required this.court,
    required this.height,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = court.sport.colors(scheme);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg, Color.alphaBlend(fg.withValues(alpha: 0.22), bg)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -height * 0.25,
              top: -height * 0.25,
              child: Container(
                width: height * 0.9,
                height: height * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: fg.withValues(alpha: 0.14), width: 2),
                ),
              ),
            ),
            Positioned(
              right: -height * 0.12,
              bottom: -height * 0.18,
              child: Icon(
                court.sport.icon,
                size: height * 0.85,
                color: fg.withValues(alpha: 0.12),
              ),
            ),
            Icon(court.sport.icon, size: height * 0.36, color: fg),
          ],
        ),
      ),
    );
  }
}