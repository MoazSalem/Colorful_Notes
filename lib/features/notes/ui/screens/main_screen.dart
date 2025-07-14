import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/core/services/settings_service.dart';
import 'package:colorful_notes/core/shared_widgets/custom_loading_widget.dart';
import 'package:colorful_notes/features/notes/ui/providers/database_provider.dart';
import 'package:colorful_notes/features/notes/ui/widgets/custom_fab.dart';
import 'package:colorful_notes/features/notes/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:colorful_notes/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final settingsService = serviceLocator<SettingsService>();
  int currentIndex = 0;

  @override
  didChangeDependencies() {
    C.theme = Theme.of(context).colorScheme;
    C.width = MediaQuery.sizeOf(context).width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext bContext) {
    return ValueListenableBuilder<SettingsModel>(
      valueListenable: settingsService.settings,
      builder: (context, settings, child) {
        return Scaffold(
          floatingActionButtonAnimator:
              FloatingActionButtonAnimator.noAnimation,
          floatingActionButtonLocation: settings.fabIndex == 0
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.startFloat,
          floatingActionButton: currentIndex != 0
              ? null
              : CustomFab(settings: settings),
          resizeToAvoidBottomInset: false,
          body: Row(
            children: [
              SideBar(
                currentIndex: currentIndex,
                onIndexChanged: (i) => {setState(() => currentIndex = i)},
              ),
              Consumer(
                builder: (context, ref, child) {
                  final database = ref.watch(databaseProvider);
                  return database.when(
                    loading: () => CustomLoadingWidget(),
                    error: (error, stackTrace) {
                      return Center(child: Text(error.toString()));
                    },
                    data: (data) {
                      return Expanded(
                        flex: 5,
                        child: AppConsts.pagesList[currentIndex],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
