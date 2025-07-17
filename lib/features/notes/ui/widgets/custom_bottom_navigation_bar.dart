import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.settings,
  });
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final SettingsModel settings;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final colors = widget.settings.colorful
        ? AppConsts.lightColors
        : List<Color>.generate(4, (_) => theme.onPrimaryContainer);
    return NavigationBar(
      height: 60,
      backgroundColor: theme.primaryContainer,
      indicatorColor: Colors.transparent,
      selectedIndex: widget.currentIndex,
      onDestinationSelected: widget.onIndexChanged,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: colors[0], size: 20),
          selectedIcon: Icon(Icons.home, color: colors[0], size: 30),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.sticky_note_2_outlined, color: colors[1], size: 20),
          selectedIcon: Icon(Icons.sticky_note_2, color: colors[1], size: 30),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.keyboard_voice_outlined, color: colors[3], size: 20),
          selectedIcon: Icon(Icons.keyboard_voice, color: colors[3], size: 30),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined, color: colors[2], size: 20),
          selectedIcon: Icon(Icons.settings, color: colors[2], size: 30),
          label: '',
        ),
      ],
    );
  }
}
