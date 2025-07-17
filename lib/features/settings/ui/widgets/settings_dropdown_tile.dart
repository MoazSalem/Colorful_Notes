import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsDropdownTile<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final double titleSize;
  final double subtitleSize;

  const SettingsDropdownTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    required this.onChanged,
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
      trailing: DropdownButton<T>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              textAlign: TextAlign.right,
              item.toString().tr(),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(),
        style: TextStyle(fontSize: 14),
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}
