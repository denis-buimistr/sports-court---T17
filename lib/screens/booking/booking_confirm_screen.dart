import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/court_tile.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_title.dart';

class BookingConfirmScreen extends StatelessWidget {
  final String courtId;
  final String slotId;

  const BookingConfirmScreen({
    super.key,
    required this.courtId,
    required this.slotId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // both ids come from the path, both objects are looked up here
    final court = MockData.courts.where((c) => c.id == courtId).firstOrNull;
    final slot = court == null
        ? null
        : MockData.slotsFor(court.id).where((s) => s.id == slotId).firstOrNull;

    if (court == null || slot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Подтверждение брони')),
        body: const Center(child: Text('Бронь не найдена')),
      );
    }

    final price = '${court.pricePerHour.toStringAsFixed(0)} MDL';

    return Scaffold(
      appBar: AppBar(title: const Text('Подтверждение брони')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(12),
            child: CourtTile(court: court),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Детали брони'),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                InfoRow(icon: Icons.calendar_today_outlined, label: 'Дата', value: slot.date),
                const Divider(height: 1),
                InfoRow(
                  icon: Icons.schedule,
                  label: 'Время',
                  value: '${slot.startTime} – ${slot.endTime}',
                ),
                const Divider(height: 1),
                const InfoRow(icon: Icons.timer_outlined, label: 'Длительность', value: '1 час'),
                const Divider(height: 1),
                InfoRow(icon: Icons.location_on_outlined, label: 'Адрес', value: court.address),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Стоимость'),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                InfoRow(label: 'Цена за час', value: price),
                const InfoRow(label: 'Количество часов', value: '× 1'),
                const Divider(height: 1),
                InfoRow(label: 'Итого', value: price, emphasized: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: scheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Бесплатная отмена за 24 часа до начала. Оплата — на месте, администратору площадки.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        caption: 'К оплате',
        value: price,
        buttonLabel: 'Подтвердить бронь',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Бронь подтверждена: ${court.name}, ${slot.startTime}'),
            ),
          );
          // go: the whole booking chain leaves the stack
          context.go('/bookings');
        },
      ),
    );
  }
}