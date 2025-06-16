import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/shared_widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colorful_notes/old_logic/notes_cubit.dart';
import 'package:colorful_notes/features/home/ui/widgets/sidebar.dart';
import 'package:colorful_notes/main.dart';

class Home extends StatefulWidget {
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
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: C.loading
              ? CustomLoadingWidget()
              : Row(
                  children: [
                    SideBar(
                      currentIndex: C.currentIndex,
                      onIndexChanged: (i) => {C.onIndexChanged(i)},
                    ),
                    Expanded(
                      flex: 5,
                      child: AppConsts.pagesList[C.currentIndex],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
