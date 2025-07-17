import 'package:colorful_notes/core/consts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final colors = AppConsts.lightColors;
    return NavigationBar(
      height: 70,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      indicatorColor: Colors.transparent,
      selectedIndex: widget.currentIndex,
      onDestinationSelected: widget.onIndexChanged,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, size: 20),
          selectedIcon: Icon(Icons.home, color: colors[0], size: 30),
          label: 'Home'.tr(),
        ),
        NavigationDestination(
          icon: Icon(Icons.sticky_note_2_outlined, size: 20),
          selectedIcon: Icon(Icons.sticky_note_2, color: colors[1], size: 30),
          label: 'Text Note'.tr(),
        ),
        NavigationDestination(
          icon: Icon(Icons.keyboard_voice_outlined, size: 20),
          selectedIcon: Icon(Icons.keyboard_voice, color: colors[3], size: 30),
          label: 'Voice Note'.tr(),
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined, size: 20),
          selectedIcon: Icon(Icons.settings, color: colors[2], size: 30),
          label: 'Settings'.tr(),
        ),
      ],
    );
  }
}
