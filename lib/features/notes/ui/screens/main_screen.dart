import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/providers/settings_notifier.dart';
import 'package:colorful_notes/core/shared_widgets/custom_loading_widget.dart';
import 'package:colorful_notes/features/notes/ui/providers/database_provider.dart';
import 'package:colorful_notes/features/notes/ui/providers/notes_provider.dart';
import 'package:colorful_notes/features/notes/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:colorful_notes/features/notes/ui/widgets/custom_fab.dart';
import 'package:colorful_notes/features/notes/ui/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    bool showSideBar = true;
    settings.whenData((settings) => showSideBar = settings.sbIndex != 4);
    List<Widget> rowChildren = [
      if (showSideBar)
        SideBar(
          currentIndex: currentIndex,
          onIndexChanged: (i) => i != currentIndex
              ? setState(() {
                  currentIndex = i;
                  ref.read(notesNotifierProvider.notifier).setLoading();
                })
              : null,
        ),
      Expanded(
        child: settings.when(
          data: (settings) => Scaffold(
            floatingActionButtonAnimator:
                FloatingActionButtonAnimator.noAnimation,
            floatingActionButtonLocation: settings.fabIndex == 0
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.startFloat,
            floatingActionButton: [3, 4].contains(currentIndex)
                ? null
                : CustomFab(settings: settings, typeIndex: currentIndex),
            resizeToAvoidBottomInset: false,
            body: Consumer(
              builder: (context, ref, child) {
                final database = ref.watch(databaseProvider);
                return database.when(
                  loading: () => CustomLoadingWidget(),
                  error: (error, stackTrace) {
                    return Center(child: Text(error.toString()));
                  },
                  data: (data) {
                    return AppConsts.pagesList[currentIndex];
                  },
                );
              },
            ),
            bottomNavigationBar: settings.sbIndex == 4
                ? CustomBottomNavigationBar(
                    currentIndex: currentIndex,
                    onIndexChanged: (i) => {setState(() => currentIndex = i)},
                    settings: settings,
                  )
                : null,
          ),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => Scaffold(body: Expanded(child: CustomLoadingWidget())),
        ),
      ),
    ];
    settings.whenData(
      (settings) => setState(
        () => [2, 3].contains(settings.sbIndex)
            ? rowChildren = rowChildren.reversed.toList()
            : null,
      ),
    );
    return Row(children: rowChildren);
  }
}
