import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const LanguageSwitcher({
    super.key,
    required this.isArabic,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: GestureDetector(
        onTap: onToggle,
        child: CircleAvatar(
          backgroundColor: theme.primary,
          child: Text(
            isArabic ? 'عر' : 'En',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: theme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
