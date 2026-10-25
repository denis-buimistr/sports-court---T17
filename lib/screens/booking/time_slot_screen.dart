import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/courts_model.dart';
import '../../models/slots_model.dart';
import '../../models/time_slot.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/court_tile.dart';
import '../../widgets/error_view.dart';
import '../../widgets/section_title.dart';
import '../../widgets/slot_chip.dart';

class TimeSlotScreen extends StatefulWidget {
  final String courtId;

  const TimeSlotScreen({super.key, required this.courtId});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  // ephemeral state: lives in the screen, not in a model
  int _dayIndex = 2;
  String? _selectedId;

  static const _days = <(String, String)>[
    ('Пн', '5'),
    ('Вт', '6'),
    ('Ср', '7'),
    ('Чт', '8'),
    ('Пт', '9'),
    ('Сб', '10'),
    ('Вс', '11'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SlotsModel>().load(widget.courtId);
    });
  }

  void _selectSlot(TimeSlot slot) {
    if (!slot.isAvailable) return; // only free slots can be selected
    setState(() => _selectedId = slot.id);
  }

  void _continue(TimeSlot? selected) {
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Выберите свободный слот, чтобы продолжить'),
        ),
      );
      return;
    }
    context.push('/courts/${widget.courtId}/slots/${selected.id}/confirm');
  }

  @override
  Widget build(BuildContext context) {
    final courtsModel = context.watch<CourtsModel>();
    final slotsModel = context.watch<SlotsModel>();
    final court = courtsModel.byId(widget.courtId);

    if (court == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Выбор времени')),
        body: Center(
          child: courtsModel.isLoading
              ? const CircularProgressIndicator()
              : const Text('Площадка не существует'),
        ),
      );
    }

    final ready = slotsModel.courtId == widget.courtId &&
        !slotsModel.isLoading &&
        slotsModel.error == null;
    final selected = ready && _selectedId != null ? slotsModel.byId(_selectedId!) : null;
    final price = court.pricePerHour.toStringAsFixed(0);

    final Widget body;
    if (slotsModel.courtId != widget.courtId || slotsModel.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (slotsModel.error != null) {
      body = ErrorView(
        message: slotsModel.error!,
        onRetry: () => context.read<SlotsModel>().load(widget.courtId),
      );
    } else {
      final slots = slotsModel.slots;
      body = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(12),
            child: CourtTile(court: court),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Выберите день', trailing: 'Октябрь 2026'),
          const SizedBox(height: 12),
          _DayStrip(
            days: _days,
            selectedIndex: _dayIndex,
            onSelect: (i) => setState(() {
              _dayIndex = i;
              _selectedId = null;
            }),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Свободное время'),
          const SizedBox(height: 12),
          const _Legend(),
          const SizedBox(height: 8),
          _SlotSection(
            title: 'Утро',
            icon: Icons.wb_sunny_outlined,
            slots: slots.sublist(0, 4),
            selectedId: _selectedId,
            onSelect: _selectSlot,
          ),
          _SlotSection(
            title: 'День',
            icon: Icons.light_mode_outlined,
            slots: slots.sublist(4, 9),
            selectedId: _selectedId,
            onSelect: _selectSlot,
          ),
          _SlotSection(
            title: 'Вечер',
            icon: Icons.nights_stay_outlined,
            slots: slots.sublist(9),
            selectedId: _selectedId,
            onSelect: _selectSlot,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Выбор времени')),
      body: body,
      bottomNavigationBar: BottomActionBar(
        caption: selected == null
            ? 'Слот не выбран'
            : '${_days[_dayIndex].$1} ${_days[_dayIndex].$2} окт, ${selected.startTime}',
        value: '$price MDL',
        buttonLabel: 'Продолжить',
        onPressed: () => _continue(selected),
      ),
    );
  }
}

class _DayStrip extends StatelessWidget {
  final List<(String, String)> days;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _DayStrip({
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (weekday, number) = days[index];
          final isSelected = index == selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onSelect(index),
            child: Container(
              width: 58,
              decoration: BoxDecoration(
                color: isSelected ? scheme.primary : scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? scheme.primary : scheme.outlineVariant,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? scheme.onPrimary : scheme.onSurface,
                    ),
                  ),
                ],
              ),
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
  final String? selectedId;
  final void Function(TimeSlot) onSelect;

  const _SlotSection({
    required this.title,
    required this.icon,
    required this.slots,
    required this.selectedId,
    required this.onSelect,
  });

  SlotState _stateOf(TimeSlot slot) {
    if (!slot.isAvailable) return SlotState.booked;
    if (slot.id == selectedId) return SlotState.selected;
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
              SlotChip(
                key: ValueKey(s.id),
                start: s.startTime,
                end: s.endTime,
                state: _stateOf(s),
                onTap: () => onSelect(s),
              ),
          ],
        ),
      ],
    );
  }
}