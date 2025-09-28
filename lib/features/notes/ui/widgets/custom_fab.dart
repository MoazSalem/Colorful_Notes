import 'dart:ui' as ui;

import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/features/notes/ui/screens/text_note.dart';
import 'package:colorful_notes/features/notes/ui/screens/voice_note.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({super.key, required this.settings, required this.typeIndex});
  final SettingsModel settings;
  final int typeIndex;

  @override
  Widget build(BuildContext context) {
    final fab = CustomFabWithChildren(
      darkColors: settings.darkColors,
      colorful: settings.colorful,
      typeIndex: typeIndex,
    );
    return settings.fabIndex == 0
        ? fab
        : Directionality(
            textDirection: settings.lang == 'en'
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            child: fab,
          );
  }
}

void _createNote(
  BuildContext context, {
  bool voice = false,
  required int typeIndex,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => voice
        ? VoiceNote(isEditing: true, typeIndex: typeIndex)
        : TextNote(isEditing: true, typeIndex: typeIndex),
  );
}

class CustomFabWithChildren extends StatefulWidget {
  const CustomFabWithChildren({
    super.key,
    required this.colorful,
    required this.typeIndex,
    required this.darkColors,
  });
  final bool colorful;
  final int typeIndex;
  final bool darkColors;
  @override
  State<CustomFabWithChildren> createState() => _CustomFabWithChildrenState();
}

class _CustomFabWithChildrenState extends State<CustomFabWithChildren> {
  bool openFab = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final colors = widget.darkColors
        ? AppConsts.darkerColors
        : AppConsts.lightColors;
    final firstBackgroundColor = widget.colorful ? colors[1] : theme.primary;
    final secondBackgroundColor = widget.colorful ? colors[2] : theme.primary;
    final foregroundColor = widget.colorful ? Colors.white : theme.onPrimary;
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: openFab
                  ? Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              openFab = !openFab;
                            });
                            _createNote(
                              context,
                              voice: true,
                              typeIndex: widget.typeIndex,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: secondBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  width: 100,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Voice Note".tr(),
                                      style: TextStyle(color: foregroundColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: secondBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.mic, color: foregroundColor),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              openFab = !openFab;
                            });
                            _createNote(
                              context,
                              voice: false,
                              typeIndex: widget.typeIndex,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: firstBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  width: 100,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Text Note".tr(),
                                      style: TextStyle(color: foregroundColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: firstBackgroundColor,
                                ),
                                child: Icon(
                                  Icons.sticky_note_2,
                                  color: foregroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(width: 160),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                openFab = !openFab;
              });
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: widget.colorful ? colors[0] : theme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(-4, 4),
                  ),
                ],
              ),

              child: Icon(
                Icons.add,
                color: widget.colorful ? Colors.white : theme.onPrimary, //white
              ),
            ),
          ),
        ],
      ),
    );
  }
}
