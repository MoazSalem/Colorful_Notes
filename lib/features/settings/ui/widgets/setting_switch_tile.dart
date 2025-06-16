import 'package:flutter/material.dart';
import 'package:switcher_button/switcher_button.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double switchSize;
  final double titleSize;
  final double subtitleSize;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.switchSize,
    required this.titleSize,
    required this.subtitleSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: subtitleSize, fontWeight: FontWeight.w300),
      ),
      trailing: SwitcherButton(
        onColor: Theme.of(context).colorScheme.primary,
        offColor: Theme.of(context).colorScheme.surfaceVariant,
        size: switchSize,
        value: value,
        onChange: onChanged,
      ),
    );
  }
}
