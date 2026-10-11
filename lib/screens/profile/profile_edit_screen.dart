import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../models/court.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Денис Буймистр');
  final _emailCtrl = TextEditingController(text: 'denis@example.com');
  final _phoneCtrl = TextEditingController(text: '60123456');
  Sport? _favoriteSport = Sport.football;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Сохранено: ${_nameCtrl.text.trim()}'),
      ),
    );
    // opened with push, closed with pop
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Личные данные')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Имя и фамилия',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return 'Введите имя и фамилию';
                if (name.length < 3) return 'Минимум 3 символа';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.mail_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Введите e-mail';
                if (!email.contains('@') || !email.contains('.')) {
                  return 'Неверный формат e-mail';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: const InputDecoration(
                labelText: 'Телефон',
                prefixText: '+373 ',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isEmpty) return 'Введите телефон';
                if (phone.length != 8) return 'Телефон должен содержать 8 цифр';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Sport>(
              initialValue: _favoriteSport,
              decoration: const InputDecoration(
                labelText: 'Любимый вид спорта',
                prefixIcon: Icon(Icons.sports_outlined),
                border: OutlineInputBorder(),
              ),
              items: [
                for (final s in Sport.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (value) => setState(() => _favoriteSport = value),
              validator: (value) => value == null ? 'Выберите вид спорта' : null,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _save,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}