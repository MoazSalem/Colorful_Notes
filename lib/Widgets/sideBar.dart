import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';

Widget sideBar(context, bool inverted) {
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      var B = NotesBloc.get(context);
      double sizeBox = B.isTablet ? 60 : 30;
      return inverted
          ? Container(
              width: B.isTablet ? 100 : 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant//Theme.of(context).backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                      onPressed: () {
                        B.onIndexChanged(4);
                      },
                      icon: B.currentIndex != 4
                          ? Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[4],
                              size: B.isTablet ? 30 : 20,
                            )
                          : Icon(
                              Icons.info,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[4],
                              size: B.isTablet ? 40 : 30,
                            )),
                  Column(
                    children: [
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            B.onIndexChanged(3);
                          },
                          icon: B.currentIndex != 3
                              ? Icon(
                                  Icons.settings_outlined,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[2],
                                  size: B.isTablet ? 30 : 20,
                                )
                              : Icon(
                                  Icons.settings,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[2],
                                  size: B.isTablet ? 40 : 30,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            B.onIndexChanged(2);
                          },
                          icon: B.currentIndex != 2
                              ? Icon(
                                  Icons.keyboard_voice_outlined,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[3],
                                  size: B.isTablet ? 34 : 24,
                                )
                              : Icon(
                                  Icons.keyboard_voice,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[3],
                                  size: B.isTablet ? 42 : 32,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            B.onIndexChanged(1);
                          },
                          icon: B.currentIndex != 1
                              ? Icon(
                                  Icons.sticky_note_2_outlined,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[1],
                                  size: B.isTablet ? 30 : 20,
                                )
                              : Icon(
                                  Icons.sticky_note_2,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[1],
                                  size: B.isTablet ? 40 : 30,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            B.onIndexChanged(0);
                          },
                          icon: B.currentIndex != 0
                              ? Icon(
                                  Icons.home_outlined,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[0],
                                  size: B.isTablet ? 32 : 22,
                                )
                              : Icon(
                                  Icons.home,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[0],
                                  size: B.isTablet ? 40 : 30,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                    ],
                  )
                ],
              ),
            )
          : Container(
              width: B.isTablet ? 100 : 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant
              ),
              child: Column(
                children: [
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 65,
                          ),
                          IconButton(
                              constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                              onPressed: () {
                                B.onIndexChanged(0);
                              },
                              icon: B.currentIndex != 0
                                  ? Icon(
                                      Icons.home_outlined,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[0],
                                      size: B.isTablet ? 32 : 22,
                                    )
                                  : Icon(
                                      Icons.home,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[0],
                                      size: B.isTablet ? 40 : 30,
                                    )),
                          SizedBox(
                            height: sizeBox,
                          ),
                          IconButton(
                              constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                              onPressed: () {
                                B.onIndexChanged(1);
                              },
                              icon: B.currentIndex != 1
                                  ? Icon(
                                      Icons.sticky_note_2_outlined,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[1],
                                      size: B.isTablet ? 30 : 20,
                                    )
                                  : Icon(
                                      Icons.sticky_note_2,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[1],
                                      size: B.isTablet ? 40 : 30,
                                    )),
                          SizedBox(
                            height: sizeBox,
                          ),
                          IconButton(
                              constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                              onPressed: () {
                                B.onIndexChanged(2);
                              },
                              icon: B.currentIndex != 2
                                  ? Icon(
                                      Icons.keyboard_voice_outlined,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[3],
                                      size: B.isTablet ? 34 : 24,
                                    )
                                  : Icon(
                                      Icons.keyboard_voice,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[3],
                                      size: B.isTablet ? 42 : 32,
                                    )),
                          SizedBox(
                            height: sizeBox,
                          ),
                          IconButton(
                              constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                              onPressed: () {
                                B.onIndexChanged(3);
                              },
                              icon: B.currentIndex != 3
                                  ? Icon(
                                      Icons.settings_outlined,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[2],
                                      size: B.isTablet ? 30 : 20,
                                    )
                                  : Icon(
                                      Icons.settings,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[2],
                                      size: B.isTablet ? 40 : 30,
                                    )),
                        ],
                      )),
                  Expanded(
                    child: IconButton(
                        constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                        onPressed: () {
                          B.onIndexChanged(4);
                        },
                        icon: B.currentIndex != 4
                            ? Icon(
                                Icons.info_outline,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[4],
                                size: B.isTablet ? 30 : 20,
                              )
                            : Icon(
                                Icons.info,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,//B.colors[4],
                                size: B.isTablet ? 40 : 30,
                              )),
                  )
                ],
              ),
            );
    },
  );
}
