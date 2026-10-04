import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';
import '../main_navigation.dart';
import 'register_screen.dart';

// static mockup: no Form, no validation
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.paddingOf(context).top + 44,
                24,
                40,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [scheme.primary, scheme.tertiary],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: scheme.onPrimary.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.sports_soccer, size: 42, color: scheme.onPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SportsCourt',
                    style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Площадка на любой вечер — за минуту',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_soccer, color: scheme.onPrimary.withValues(alpha: 0.8)),
                      const SizedBox(width: 18),
                      Icon(Icons.sports_tennis, color: scheme.onPrimary.withValues(alpha: 0.8)),
                      const SizedBox(width: 18),
                      Icon(Icons.sports_basketball, color: scheme.onPrimary.withValues(alpha: 0.8)),
                      const SizedBox(width: 18),
                      Icon(Icons.sports_volleyball, color: scheme.onPrimary.withValues(alpha: 0.8)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('С возвращением', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Войдите, чтобы управлять бронями',
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
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
                    suffix: Icon(Icons.visibility_outlined),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Забыли пароль?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigation()),
                    ),
                    child: const Text('Войти'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Нет аккаунта?',
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        ),
                        child: const Text('Зарегистрируйтесь'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}