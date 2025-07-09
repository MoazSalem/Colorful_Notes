import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/old_logic/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class AppbarActionWidgets extends StatelessWidget {
  const AppbarActionWidgets({
    super.key,
    required this.settings,
    required this.C,
    required this.searchController,
    required this.onToggle,
  });
  final SettingsModel settings;
  final NotesCubit C;
  final VoidCallback onToggle;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    final viewIndex = serviceLocator<Box>().get('viewIndex') ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onToggle,
          icon: Icon(
            Icons.search,
            size: 30,
            color: searchController.text.isNotEmpty
                ? (settings.colorful ? C.colors[0] : C.theme.primary)
                : C.theme.onSurfaceVariant,
          ),
        ),
        IconButton(
          onPressed: () {
            int newIndex = viewIndex < 2 ? viewIndex + 1 : 0;
            serviceLocator<Box>().put("viewIndex", newIndex);
            C.onChanged(); // Trigger a state change to rebuild
          },
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
