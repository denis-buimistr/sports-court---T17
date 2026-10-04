// lib/screens/courts/courts_list_screen.dart
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widgets/court_card.dart';
import 'court_details_screen.dart';

class CourtsListScreen extends StatelessWidget {
  const CourtsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Площадки')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск площадки...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  Chip(label: Text('Все')),
                  SizedBox(width: 8),
                  Chip(label: Text('Футбол')),
                  SizedBox(width: 8),
                  Chip(label: Text('Теннис')),
                  SizedBox(width: 8),
                  Chip(label: Text('Баскетбол')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.courts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final court = MockData.courts[index];
                return CourtCard(
                  court: court,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CourtDetailsScreen(court: court)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}