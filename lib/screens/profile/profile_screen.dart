import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widgets/app_card.dart';
import '../../widgets/court_tile.dart';
import '../../widgets/section_title.dart';
import '../../widgets/stat_tile.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final favorites = MockData.courts.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                'ДБ',
                style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text('Денис Буймистр', style: theme.textTheme.titleLarge)),
          const SizedBox(height: 2),
          Center(
            child: Text(
              'denis@example.com',
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: StatTile(icon: Icons.event_available_outlined, value: '12', label: 'броней')),
              SizedBox(width: 12),
              Expanded(child: StatTile(icon: Icons.timer_outlined, value: '18 ч', label: 'на площадках')),
              SizedBox(width: 12),
              Expanded(child: StatTile(icon: Icons.sports_soccer, value: 'Футбол', label: 'любимый спорт')),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('Любимые площадки'),
          const SizedBox(height: 8),
          AppCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (var i = 0; i < favorites.length; i++) ...[
                  if (i > 0) const Divider(height: 24),
                  CourtTile(
                    court: favorites[i],
                    trailing: Icon(Icons.favorite, color: scheme.primary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Настройки'),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Личные данные'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text('Способы оплаты'),
                  trailing: Icon(Icons.chevron_right),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: const Text('Уведомления'),
                  trailing: Switch(value: true, onChanged: (_) {}),
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Язык'),
                  trailing: Text('Русский'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(Icons.logout, color: scheme.error),
                  title: Text('Выйти', style: TextStyle(color: scheme.error)),
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
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