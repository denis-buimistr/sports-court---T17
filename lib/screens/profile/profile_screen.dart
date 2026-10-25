import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/mock_store.dart';
import '../../models/bookings_model.dart';
import '../../models/courts_model.dart';
import '../../widgets/app_card.dart';
import '../../widgets/court_tile.dart';
import '../../widgets/section_title.dart';
import '../../widgets/stat_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ephemeral state: the switch position lives in the screen
  bool _simulateError = false;

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Придётся войти заново, чтобы управлять бронями.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Нет'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Да, выйти'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final bookings = context.watch<BookingsModel>();
    final favorites = context.watch<CourtsModel>().courts.take(3).toList();

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
          // the stats come from the same model: one mutation moves them all
          Row(
            children: [
              Expanded(
                child: StatTile(
                  icon: Icons.event_available_outlined,
                  value: '${bookings.bookings.length}',
                  label: 'броней',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  icon: Icons.upcoming_outlined,
                  value: '${bookings.upcomingCount}',
                  label: 'предстоящих',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  icon: Icons.payments_outlined,
                  value: '${bookings.totalSpent.toStringAsFixed(0)} MDL',
                  label: 'потрачено',
                ),
              ),
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
          const SectionTitle('Разработка'),
          const SizedBox(height: 8),
          AppCard(
            child: SwitchListTile(
              secondary: Icon(Icons.wifi_off, color: scheme.error),
              title: const Text('Симулировать сбой сети'),
              subtitle: const Text('Любой запрос к хранилищу вернёт ошибку'),
              value: _simulateError,
              onChanged: (value) {
                setState(() => _simulateError = value);
                // the only UI place allowed to know about the mock
                context.read<MockStore>().simulateError = value;
              },
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Настройки'),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Личные данные'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/profile/edit'),
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text('Способы оплаты'),
                  trailing: Icon(Icons.chevron_right),
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
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}