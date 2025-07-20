import 'package:colorful_notes/core/consts.dart';
import 'package:flutter/material.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/core/services/settings_service.dart';

/// Data class to hold information for each sidebar button.
class _SideBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final int index;

  const _SideBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.index,
  });
}

class SideBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const SideBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  static const List<_SideBarItem> _navItems = [
    _SideBarItem(icon: Icons.home_outlined, selectedIcon: Icons.home, index: 0),
    _SideBarItem(
      icon: Icons.sticky_note_2_outlined,
      selectedIcon: Icons.sticky_note_2_sharp,
      index: 1,
    ),
    _SideBarItem(
      icon: Icons.keyboard_voice_outlined,
      selectedIcon: Icons.keyboard_voice,
      index: 2,
    ),
    _SideBarItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      index: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final settingsService = serviceLocator<SettingsService>();
    final theme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<SettingsModel>(
      valueListenable: settingsService.settings,
      builder: (context, settings, child) {
        // Determine if the layout should be inverted (bottom-aligned)
        // based on the settings from the service.
        final bool isInverted = settings.sbIndex == 1 || settings.sbIndex == 3;
        final double sizeBox = 10;

        // Build the list of main navigation buttons
        final List<Widget> navButtons = _navItems
            .map(
              (item) => _SideBarButton(
                item: item,
                isSelected: currentIndex == item.index,
                settings: settings,
                onPressed: () => onIndexChanged(item.index),
              ),
            )
            .toList();
        return Container(
          width: 60,
          decoration: BoxDecoration(color: theme.surfaceContainerHigh),
          child: isInverted
              ? _buildInvertedLayout(navButtons.reversed.toList(), sizeBox)
              : _buildNormalLayout(navButtons, sizeBox),
        );
      },
    );
  }

  /// Builds the top-aligned layout.
  Widget _buildNormalLayout(List<Widget> navButtons, double spacing) {
    return Column(
      children: [
        const SizedBox(height: 65), // Top padding
        ...navButtons.expand((button) => [button, SizedBox(height: spacing)]),
        const Spacer(), // Bottom padding
      ],
    );
  }

  /// Builds the bottom-aligned (inverted) layout.
  Widget _buildInvertedLayout(List<Widget> navButtons, double spacing) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...navButtons.expand((button) => [button, SizedBox(height: spacing)]),
      ],
    );
  }
}

/// A private, reusable button widget for the sidebar.
class _SideBarButton extends StatelessWidget {
  final _SideBarItem item;
  final bool isSelected;
  final SettingsModel settings;
  final VoidCallback onPressed;

  const _SideBarButton({
    required this.item,
    required this.isSelected,
    required this.settings,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double selectedSize = 30;
    final double unselectedSize = 20;

    return IconButton(
      constraints: const BoxConstraints.tightFor(width: 60, height: 60),
      onPressed: onPressed,
      icon: Icon(
        isSelected ? item.selectedIcon : item.icon,
        size: isSelected ? selectedSize : unselectedSize,
        color: settings.colorful
            ? AppConsts.lightColors[item.index]
            : theme.onSurfaceVariant,
      ),
    );
  }
}
