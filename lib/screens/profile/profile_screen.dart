// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text('DB', style: TextStyle(fontSize: 28, color: scheme.onPrimaryContainer)),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('Denis Buimistr', style: Theme.of(context).textTheme.titleLarge),
          ),
          Center(
            child: Text('denis.buimistr@example.com', style: TextStyle(color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: const [
                ListTile(leading: Icon(Icons.history), title: Text('История броней')),
                Divider(height: 1),
                ListTile(leading: Icon(Icons.favorite_border), title: Text('Избранные площадки')),
                Divider(height: 1),
                ListTile(leading: Icon(Icons.settings_outlined), title: Text('Настройки')),
                Divider(height: 1),
                ListTile(leading: Icon(Icons.logout), title: Text('Выйти')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}