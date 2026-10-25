import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/court.dart';
import '../../models/courts_model.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/court_card.dart';
import '../../widgets/error_view.dart';
import '../../widgets/filter_chips_row.dart';
import '../../widgets/section_title.dart';
import '../../widgets/sport_style.dart';

class CourtsListScreen extends StatelessWidget {
  const CourtsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CourtsModel>(); // watch in build

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!,
        onRetry: () => context.read<CourtsModel>().load(), // read in a callback
      );
    } else {
      body = _CourtsList(courts: model.courts, districts: model.districts);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Площадки'),
        actions: [
          IconButton(
            onPressed: () => context.read<CourtsModel>().load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: body,
    );
  }
}

class _CourtsList extends StatelessWidget {
  final List<Court> courts;
  final List<String> districts;

  const _CourtsList({required this.courts, required this.districts});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            for (final d in districts) FilterOption(d),
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
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final court = courts[index];
              return CourtCard(
                key: ValueKey(court.id), // identity from the data
                court: court,
                onTap: () => context.push('/courts/${court.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}