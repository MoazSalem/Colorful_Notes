import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class AppbarActionWidgets extends StatelessWidget {
  const AppbarActionWidgets({
    super.key,
    required this.settings,
    required this.searchController,
    required this.onToggle,
    required this.switchView,
    required this.viewIndex,
  });
  final SettingsModel settings;
  final VoidCallback onToggle;
  final VoidCallback switchView;
  final TextEditingController searchController;
  final int viewIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(onPressed: onToggle, icon: Icon(Icons.search, size: 30)),
        IconButton(
          onPressed: switchView,
          icon: viewIndex == 0
              ? const Icon(Icons.indeterminate_check_box_sharp)
              : viewIndex == 1
              ? const Icon(Icons.view_agenda_sharp)
              : const Icon(Icons.grid_view_sharp),
        ),
      ],
    );
  }
}
