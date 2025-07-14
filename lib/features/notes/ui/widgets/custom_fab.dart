import 'dart:ui' as ui;
import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/features/notes/ui/screens/text_note.dart';
import 'package:colorful_notes/features/notes/ui/screens/voice_note.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({super.key, required this.settings});
  final SettingsModel settings;

  @override
  Widget build(BuildContext context) {
    final fab = CustomFabWithChildren(colorful: settings.colorful);
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

void _createNote(BuildContext context, {bool voice = false}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => voice ? const VoiceNote() : const TextNote(),
  );
}

class CustomFabWithChildren extends StatefulWidget {
  const CustomFabWithChildren({super.key, required this.colorful});
  final bool colorful;
  @override
  State<CustomFabWithChildren> createState() => _CustomFabWithChildrenState();
}

class _CustomFabWithChildrenState extends State<CustomFabWithChildren> {
  bool openFab = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final colors = AppConsts.lightColors;
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: openFab
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              openFab = !openFab;
                            });
                            _createNote(context, voice: true);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: theme.secondary,
                                  ),
                                  width: 100,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Voice Note".tr(),
                                      style: TextStyle(
                                        color: widget.colorful
                                            ? colors[3]
                                            : theme.onSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: FloatingActionButton(
                                  backgroundColor: theme.secondary,
                                  mini: true,
                                  onPressed: () {
                                    setState(() {
                                      openFab = !openFab;
                                    });
                                    _createNote(context, voice: true);
                                  },
                                  elevation: 0,
                                  child: Icon(
                                    Icons.mic,
                                    color: widget.colorful
                                        ? colors[3]
                                        : theme.onSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              openFab = !openFab;
                            });
                            _createNote(context, voice: false);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: theme.secondary,
                                  ),
                                  width: 100,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Text Note".tr(),
                                      style: TextStyle(
                                        color: widget.colorful
                                            ? colors[1]
                                            : theme.onSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      openFab = !openFab;
                                    });
                                    _createNote(context, voice: false);
                                  },
                                  backgroundColor: theme.secondary,
                                  mini: true,
                                  elevation: 0,
                                  child: Icon(
                                    Icons.sticky_note_2,
                                    color: widget.colorful
                                        ? colors[1]
                                        : theme.onSecondary,
                                  ),
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
          FloatingActionButton(
            backgroundColor: widget.colorful ? colors[0] : theme.primary,
            onPressed: () {
              setState(() {
                openFab = !openFab;
              });
            },
            elevation: 0,
            child: Icon(
              Icons.add,
              color: theme.onPrimary, //white
            ),
          ),
        ],
      ),
    );
  }
}
