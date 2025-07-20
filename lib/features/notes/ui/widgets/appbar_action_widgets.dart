import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:flutter/material.dart';

class AppbarActionWidgets extends StatelessWidget {
  const AppbarActionWidgets({
    super.key,
    required this.settings,
    required this.onToggle,
    required this.switchView,
    required this.viewIndex,
  });
  final SettingsModel settings;
  final VoidCallback onToggle;
  final VoidCallback switchView;
  final int viewIndex;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final color = theme.onSurfaceVariant;
    final colors = settings.darkColors
        ? AppConsts.darkerColors
        : AppConsts.lightColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onToggle,
          icon: Icon(Icons.search, size: 30),
          color: settings.colorful ? colors[0] : color,
        ),
        IconButton(
          onPressed: switchView,
          icon: viewIndex == 0
              ? Icon(
                  Icons.indeterminate_check_box_sharp,
                  size: 28,
                  color: settings.colorful ? colors[2] : color,
                )
              : viewIndex == 1
              ? Icon(
                  Icons.view_agenda_sharp,
                  size: 28,
                  color: settings.colorful ? colors[3] : color,
                )
              : Icon(
                  Icons.grid_view_sharp,
                  size: 28,
                  color: settings.colorful ? colors[4] : color,
                ),
        ),
      ],
    );
  }
}
