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

class CourtsListScreen extends StatefulWidget {
  const CourtsListScreen({super.key});

  @override
  State<CourtsListScreen> createState() => _CourtsListScreenState();
}

class _CourtsListScreenState extends State<CourtsListScreen> {
  // ephemeral: the text being typed lives in the screen, the applied
  // search lives in the model (it survives the loading spinner and retry)
  late final _searchCtrl = TextEditingController(
    text: context.read<CourtsModel>().search ?? '',
  );

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
      body = _CourtsList(
        courts: model.courts,
        districts: model.districts,
        hasMore: model.hasMore,
      );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: AppTextField(
              controller: _searchCtrl,
              hint: 'Поиск по названию, району или адресу',
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              // the search happens on the server (L5 task 6)
              onSubmitted: (q) =>
                  context.read<CourtsModel>().load(search: q.trim()),
              suffix: IconButton(
                tooltip: 'Сбросить поиск',
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchCtrl.clear();
                  context.read<CourtsModel>().load(search: '');
                },
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _CourtsList extends StatelessWidget {
  final List<Court> courts;
  final List<String> districts;
  final bool hasMore;

  const _CourtsList({
    required this.courts,
    required this.districts,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          child: SectionTitle(
            'Рядом с вами',
            trailing: '${courts.length} площадок',
          ),
        ),
        Expanded(
          child: courts.isEmpty
              ? const Center(child: Text('Ничего не найдено'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  // + 1: the tail that asks for the next page
                  itemCount: courts.length + (hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == courts.length) {
                      // the last item is visible -> ask for the next slice
                      context.read<CourtsModel>().loadMore();
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                    }
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
