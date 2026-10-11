import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../widgets/amenity_chip.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/court_photo.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_title.dart';
import '../../widgets/sport_badge.dart';

class CourtDetailsScreen extends StatelessWidget {
  final String courtId;

  const CourtDetailsScreen({super.key, required this.courtId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // the id travels in the path, the screen looks the object up itself
    final court = MockData.courts.where((c) => c.id == courtId).firstOrNull;
    if (court == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Площадка')),
        body: const Center(child: Text('Площадка не найдена')),
      );
    }

    final slots = MockData.slotsFor(court.id);
    final free = slots.where((s) => s.isAvailable).length;
    final price = court.pricePerHour.toStringAsFixed(0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(court.name),
              background: CourtPhoto(court: court, height: 260),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SportBadge(court.sport),
                      const SizedBox(width: 10),
                      Icon(Icons.schedule, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'Открыто 08:00 – 22:00',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Цена за час',
                                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$price MDL',
                                style: theme.textTheme.headlineSmall?.copyWith(color: scheme.primary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Сегодня свободно',
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text('$free из ${slots.length} слотов', style: theme.textTheme.titleMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle('Удобства'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final a in court.amenities) AmenityChip(a)],
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle('Информация'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        InfoRow(icon: Icons.location_on_outlined, label: 'Адрес', value: court.address),
                        const Divider(height: 1),
                        InfoRow(icon: Icons.map_outlined, label: 'Район', value: court.district),
                        const Divider(height: 1),
                        const InfoRow(icon: Icons.schedule, label: 'Пн–Пт', value: '08:00 – 22:00'),
                        const Divider(height: 1),
                        const InfoRow(icon: Icons.weekend_outlined, label: 'Сб–Вс', value: '09:00 – 23:00'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        caption: 'Цена за час',
        value: '$price MDL',
        buttonLabel: 'Выбрать время',
        onPressed: () => context.push('/courts/${court.id}/slots'),
      ),
    );
  }
}