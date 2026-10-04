import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../main_navigation.dart';

// static mockup: four fields and a button
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Создайте аккаунт', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Это займёт меньше минуты',
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            const AppTextField(label: 'Имя и фамилия', prefixIcon: Icons.person_outline),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'E-mail',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Пароль',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 14),
            const AppTextField(
              label: 'Повторите пароль',
              prefixIcon: Icons.lock_reset_outlined,
              obscureText: true,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigation()),
                (route) => false,
              ),
              child: const Text('Создать аккаунт'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Уже есть аккаунт?',
                  style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Войти'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}