import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Widgets/notes.dart';

bool openFab = false;

Widget customFab(ColorScheme theme, colors, action1, action2, bool colorful) {
  return StatefulBuilder(
    builder: (context, setState) => SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: isTablet ? 0 : 8, vertical: isTablet ? 12 : 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: openFab
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              openFab = !openFab;
                              action2();
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isTablet ? 8.0 : 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: theme.surfaceVariant,
                                      ),
                                      width: isTablet ? 160 : 100,
                                      height: isTablet ? 50 : 40,
                                      child: Center(
                                          child: Text(
                                        "Voice Note".tr(),
                                        style:
                                            TextStyle(color: colorful ? colors[3] : theme.primary),
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: isTablet ? 60 : 40,
                                    child: FloatingActionButton(
                                      backgroundColor: theme.surfaceVariant,
                                      mini: isTablet ? false : true,
                                      onPressed: () {
                                        openFab = !openFab;
                                        action2();
                                        setState(() {});
                                      },
                                      elevation: 0,
                                      child: Icon(
                                        Icons.mic,
                                        color: colorful ? colors[3] : theme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              openFab = !openFab;
                              action1();
                              setState(() {});
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: theme.surfaceVariant, //colors[1],
                                    ),
                                    width: isTablet ? 160 : 100,
                                    height: isTablet ? 50 : 40,
                                    child: Center(
                                        child: Text(
                                      "Text Note".tr(),
                                      style: TextStyle(color: colorful ? colors[1] : theme.primary),
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  width: isTablet ? 60 : 40,
                                  child: FloatingActionButton(
                                    backgroundColor: theme.surfaceVariant,
                                    //colors[1],
                                    mini: isTablet ? false : true,
                                    onPressed: () {
                                      openFab = !openFab;
                                      action1();
                                      setState(() {});
                                    },
                                    elevation: 0,
                                    child: Icon(
                                      Icons.sticky_note_2,
                                      color: colorful ? colors[1] : theme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        width: isTablet ? 200 : 160,
                      ),
              )),
          FloatingActionButton(
            backgroundColor: colorful ? colors[0] : theme.primary,
            //openFab ? colors[afterTap] : colors[main],
            //splashColor: theme.primaryContainer,
            //openFab ? colors[main] : colors[afterTap],
            onPressed: () {
              openFab = !openFab;
              setState(() {});
            },
            elevation: 0,

            child: Icon(
              Icons.add,
              color: theme.surfaceVariant, //white
            ),
          ),
        ],
      ),
    ),
  );
}
