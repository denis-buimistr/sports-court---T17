import 'package:flutter/material.dart';
import '../models/court.dart';

extension SportStyle on Sport {
  IconData get icon => switch (this) {
        Sport.football => Icons.sports_soccer,
        Sport.tennis => Icons.sports_tennis,
        Sport.basketball => Icons.sports_basketball,
        Sport.volleyball => Icons.sports_volleyball,
      };

  // (background, content) from the color scheme
  (Color, Color) colors(ColorScheme s) => switch (this) {
        Sport.football => (s.primaryContainer, s.onPrimaryContainer),
        Sport.tennis => (s.tertiaryContainer, s.onTertiaryContainer),
        Sport.basketball => (s.secondaryContainer, s.onSecondaryContainer),
        Sport.volleyball => (s.primary, s.onPrimary),
      };
}