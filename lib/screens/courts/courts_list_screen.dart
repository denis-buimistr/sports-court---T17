import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/court.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/court_card.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/section_title.dart';
import '../../widgets/sport_style.dart';
import 'court_details_screen.dart';

// search and filters are visual only until L4
class CourtsListScreen extends StatelessWidget {
  const CourtsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courts = MockData.courts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Площадки'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: AppTextField(
              hint: 'Поиск по названию или адресу',
              prefixIcon: Icons.search,
              suffix: Icon(Icons.tune),
            ),
          ),
          FilterChipsRow(
            options: [
              const FilterOption('Все виды спорта'),
              for (final s in Sport.values) FilterOption(s.label, icon: s.icon),
            ],
          ),
          const SizedBox(height: 8),
          FilterChipsRow(
            options: [
              const FilterOption('Все районы', icon: Icons.place_outlined),
              for (final d in MockData.districts) FilterOption(d),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SectionTitle('Рядом с вами', trailing: '${courts.length} площадок'),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: courts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final court = courts[index];
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
