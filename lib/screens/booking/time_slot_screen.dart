import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/court.dart';
import '../../models/time_slot.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/court_tile.dart';
import '../../widgets/section_title.dart';
import '../../widgets/slot_chip.dart';
import 'booking_confirm_screen.dart';

// selected day and slot are hardcoded for the mockup
class TimeSlotScreen extends StatelessWidget {
  final Court court;

  const TimeSlotScreen({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    final slots = MockData.slotsFor(court.id);
    final price = court.pricePerHour.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Выбор времени')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(12),
            child: CourtTile(court: court),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Выберите день', trailing: 'Октябрь 2026'),
          const SizedBox(height: 12),
          const _DayStrip(),
          const SizedBox(height: 24),
          const SectionTitle('Свободное время'),
          const SizedBox(height: 12),
          const _Legend(),
          const SizedBox(height: 8),
          _SlotSection(title: 'Утро', icon: Icons.wb_sunny_outlined, slots: slots.sublist(0, 4)),
          _SlotSection(title: 'День', icon: Icons.light_mode_outlined, slots: slots.sublist(4, 9)),
          _SlotSection(title: 'Вечер', icon: Icons.nights_stay_outlined, slots: slots.sublist(9)),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        caption: '${MockData.demoDate}, ${MockData.demoStart}',
        value: '$price MDL',
        buttonLabel: 'Продолжить',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingConfirmScreen(court: court)),
        ),
      ),
    );
  }
}

class _DayStrip extends StatelessWidget {
  const _DayStrip();

  static const _days = <(String, String)>[
    ('Пн', '5'),
    ('Вт', '6'),
    ('Ср', '7'),
    ('Чт', '8'),
    ('Пт', '9'),
    ('Сб', '10'),
    ('Вс', '11'),
  ];
  static const _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (weekday, number) = _days[index];
          final selected = index == _selectedIndex;

          return Container(
            width: 58,
            decoration: BoxDecoration(
              color: selected ? scheme.primary : scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: selected ? scheme.primary : scheme.outlineVariant),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: selected ? scheme.onPrimary : scheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 18,
      runSpacing: 8,
      children: [
        _LegendItem(label: 'Свободно', fill: scheme.surfaceContainerLow, border: scheme.outlineVariant),
        _LegendItem(label: 'Выбрано', fill: scheme.primary, border: scheme.primary),
        _LegendItem(
          label: 'Занято',
          fill: scheme.surfaceContainerHighest,
          border: scheme.surfaceContainerHighest,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color fill;
  final Color border;

  const _LegendItem({required this.label, required this.fill, required this.border});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SlotSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<TimeSlot> slots;

  const _SlotSection({required this.title, required this.icon, required this.slots});

  SlotState _stateOf(TimeSlot slot) {
    if (!slot.isAvailable) return SlotState.booked;
    if (slot.startTime == MockData.demoStart) return SlotState.selected;
    return SlotState.available;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.7,
          children: [
            for (final s in slots)
              SlotChip(start: s.startTime, end: s.endTime, state: _stateOf(s)),
          ],
        ),
      ],
    );
  }
}