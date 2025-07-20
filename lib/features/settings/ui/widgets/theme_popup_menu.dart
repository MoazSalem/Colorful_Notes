import 'package:colorful_notes/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ThemePopupMenu extends StatelessWidget {
  const ThemePopupMenu({
    super.key,
    required this.themeIndex,
    required this.onChanged,
    this.contentPadding,
  });

  final int themeIndex;
  final ValueChanged<int> onChanged;

  // Defaults to 16, like ListTile does.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final themesValues = AppTheme.themeColors.values.toList();
    final themesNames = AppTheme.themeColors.keys.toList();
    return PopupMenuButton<int>(
      tooltip: '',
      padding: EdgeInsets.zero,
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        for (int i = 0; i < themesNames.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.lens, color: themesValues[i], size: 35),
              title: Text(themesNames[i]),
            ),
          ),
      ],
      child: ListTile(
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          "Current Theme".tr(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          "${themesNames[themeIndex]}  - You currently need to restart the app for changes to take effect.",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
        ),
        trailing: Icon(Icons.lens, color: themesValues[themeIndex], size: 40),
      ),
    );
  }
}
