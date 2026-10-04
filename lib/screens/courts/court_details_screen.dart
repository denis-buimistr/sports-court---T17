// lib/screens/courts/court_details_screen.dart
import 'package:flutter/material.dart';
import '../../models/court.dart';
import '../booking/time_slot_screen.dart';

class CourtDetailsScreen extends StatelessWidget {
  final Court court;

  const CourtDetailsScreen({super.key, required this.court});
  
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(court.name)),
      body: ListView(
        children: [
          Image.network(court.imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(court.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 18, color: scheme.primary),
                    const SizedBox(width: 4),
                    Expanded(child: Text(court.address)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${court.pricePerHour.toStringAsFixed(0)} MDL / час',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: scheme.primary),
                ),
                const SizedBox(height: 20),
                Text('Удобства', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: court.amenities
                      .map((a) => Chip(label: Text(a)))
                      .toList(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TimeSlotScreen(court: court)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Text('Выбрать время'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}