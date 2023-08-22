import 'package:flutter/material.dart';
import 'package:notes/Cubit/notes_cubit.dart';

Widget sideBar(
    {required ColorScheme theme,
    required bool inverted,
    required NotesCubit C,
    required double sizeBox}) {
  return inverted
      ? Container(
          width: C.isTablet ? 100 : 60,
          decoration:
              BoxDecoration(color: theme.surfaceVariant //Theme.of(context).backgroundColor,
                  ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                  onPressed: () {
                    C.onIndexChanged(4);
                  },
                  icon: C.currentIndex != 4
                      ? Icon(
                          Icons.info_outline,
                          color: C.colorful ? C.colors[4] : theme.onSurfaceVariant,
                          size: C.isTablet ? 30 : 20,
                        )
                      : Icon(
                          Icons.info,
                          color: C.colorful ? C.colors[4] : theme.onSurfaceVariant,
                          size: C.isTablet ? 40 : 30,
                        )),
              Column(
                children: [
                  SizedBox(
                    height: sizeBox,
                  ),
                  IconButton(
                      constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                      onPressed: () {
                        C.onIndexChanged(3);
                      },
                      icon: C.currentIndex != 3
                          ? Icon(
                              Icons.settings_outlined,
                              color: C.colorful ? C.colors[2] : theme.onSurfaceVariant,
                              size: C.isTablet ? 30 : 20,
                            )
                          : Icon(
                              Icons.settings_rounded,
                              color: C.colorful ? C.colors[2] : theme.onSurfaceVariant,
                              size: C.isTablet ? 40 : 30,
                            )),
                  SizedBox(
                    height: sizeBox,
                  ),
                  IconButton(
                      constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                      onPressed: () {
                        C.onIndexChanged(2);
                      },
                      icon: C.currentIndex != 2
                          ? Icon(
                              Icons.keyboard_voice_outlined,
                              color: C.colorful ? C.colors[3] : theme.onSurfaceVariant,
                              size: C.isTablet ? 34 : 24,
                            )
                          : Icon(
                              Icons.keyboard_voice,
                              color: C.colorful ? C.colors[3] : theme.onSurfaceVariant,
                              size: C.isTablet ? 42 : 32,
                            )),
                  SizedBox(
                    height: sizeBox,
                  ),
                  IconButton(
                      constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                      onPressed: () {
                        C.onIndexChanged(1);
                      },
                      icon: C.currentIndex != 1
                          ? Icon(
                              Icons.sticky_note_2_outlined,
                              color: C.colorful ? C.colors[1] : theme.onSurfaceVariant,
                              size: C.isTablet ? 30 : 20,
                            )
                          : Icon(
                              Icons.sticky_note_2_sharp,
                              color: C.colorful ? C.colors[1] : theme.onSurfaceVariant,
                              size: C.isTablet ? 40 : 30,
                            )),
                  SizedBox(
                    height: sizeBox,
                  ),
                  IconButton(
                      constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                      onPressed: () {
                        C.onIndexChanged(0);
                      },
                      icon: C.currentIndex != 0
                          ? Icon(
                              Icons.home_outlined,
                              color: C.colorful ? C.colors[0] : theme.onSurfaceVariant,
                              size: C.isTablet ? 32 : 22,
                            )
                          : Icon(
                              Icons.home,
                              color: C.colorful ? C.colors[0] : theme.onSurfaceVariant,
                              size: C.isTablet ? 40 : 30,
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
          width: C.isTablet ? 100 : 60,
          decoration: BoxDecoration(color: theme.surfaceVariant),
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
                            C.onIndexChanged(0);
                          },
                          icon: C.currentIndex != 0
                              ? Icon(
                                  Icons.home_outlined,
                                  color: C.colorful ? C.colors[0] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 32 : 22,
                                )
                              : Icon(
                                  Icons.home,
                                  color: C.colorful ? C.colors[0] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 40 : 30,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            C.onIndexChanged(1);
                          },
                          icon: C.currentIndex != 1
                              ? Icon(
                                  Icons.sticky_note_2_outlined,
                                  color: C.colorful ? C.colors[1] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 30 : 20,
                                )
                              : Icon(
                                  Icons.sticky_note_2_sharp,
                                  color: C.colorful ? C.colors[1] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 40 : 30,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            C.onIndexChanged(2);
                          },
                          icon: C.currentIndex != 2
                              ? Icon(
                                  Icons.keyboard_voice_outlined,
                                  color: C.colorful ? C.colors[3] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 34 : 24,
                                )
                              : Icon(
                                  Icons.keyboard_voice,
                                  color: C.colorful ? C.colors[3] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 42 : 32,
                                )),
                      SizedBox(
                        height: sizeBox,
                      ),
                      IconButton(
                          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                          onPressed: () {
                            C.onIndexChanged(3);
                          },
                          icon: C.currentIndex != 3
                              ? Icon(
                                  Icons.settings_outlined,
                                  color: C.colorful ? C.colors[2] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 30 : 20,
                                )
                              : Icon(
                                  Icons.settings_rounded,
                                  color: C.colorful ? C.colors[2] : theme.onSurfaceVariant,
                                  size: C.isTablet ? 40 : 30,
                                )),
                    ],
                  )),
              Expanded(
                child: IconButton(
                    constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                    onPressed: () {
                      C.onIndexChanged(4);
                    },
                    icon: C.currentIndex != 4
                        ? Icon(
                            Icons.info_outline,
                            color: C.colorful ? C.colors[4] : theme.onSurfaceVariant,
                            size: C.isTablet ? 30 : 20,
                          )
                        : Icon(
                            Icons.info,
                            color: C.colorful ? C.colors[4] : theme.onSurfaceVariant,
                            size: C.isTablet ? 40 : 30,
                          )),
              )
            ],
          ),
        );
}
