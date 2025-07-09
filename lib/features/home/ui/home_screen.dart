import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/services/notes_database.dart';
import 'package:colorful_notes/core/shared_widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:colorful_notes/features/home/ui/widgets/sidebar.dart';
import 'package:colorful_notes/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = FutureProvider<NotesDatabase>((ref) async {
  final db = NotesDatabase();
  await db.startDatabase();
  return db;
});

final class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  didChangeDependencies() {
    C.theme = Theme.of(context).colorScheme;
    C.width = MediaQuery.sizeOf(context).width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          SideBar(
            currentIndex: C.currentIndex,
            onIndexChanged: (i) => {C.onIndexChanged(i)},
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
                    child: AppConsts.pagesList[C.currentIndex],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
