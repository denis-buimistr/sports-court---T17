import 'package:flutter/material.dart';

// no Form / validator until L3
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = prefixIcon;

    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon == null ? null : Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );
  }
}