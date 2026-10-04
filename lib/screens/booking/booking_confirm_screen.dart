import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/court.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/court_tile.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_title.dart';
import '../main_navigation.dart';

// summary + total, slot data comes from MockData
class BookingConfirmScreen extends StatelessWidget {
  final Court court;

  const BookingConfirmScreen({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
                const InfoRow(icon: Icons.calendar_today_outlined, label: 'Дата', value: MockData.demoDate),
                const Divider(height: 1),
                const InfoRow(
                  icon: Icons.schedule,
                  label: 'Время',
                  value: '${MockData.demoStart} – ${MockData.demoEnd}',
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
          final messenger = ScaffoldMessenger.of(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 1)),
            (route) => false,
          );
          messenger.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Бронь подтверждена: ${court.name}, ${MockData.demoDate}'),
            ),
          );
        },
      ),
    );
  }
}