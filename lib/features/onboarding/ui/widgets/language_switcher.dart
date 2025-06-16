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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: GestureDetector(
        onTap: onToggle,
        child: CircleAvatar(
          child: Text(
            isArabic ? 'عر' : 'En',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
        ),
      ),
    );
  }
}
