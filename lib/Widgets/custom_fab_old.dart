import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes/Widgets/notes.dart';

Widget customFabOld(BuildContext context, bool openFab, colors, shadeColors, bool hide, int main, int afterTap, action1, action2, action3) {
  return StatefulBuilder(
    builder: (context, setState) => SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 8, vertical: isTablet ? 12 : 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: openFab
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              action3();
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadeColors[3].withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(40),
                                        color: colors[3],
                                      ),
                                      width: isTablet ? 160 : 100,
                                      height: isTablet ? 40 : 30,
                                      child: Center(
                                          child: Text(
                                        "Voice Note".tr(),
                                        style: const TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                  Container(
                                    width: isTablet ? 60 : 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: shadeColors[3].withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: FloatingActionButton(
                                      backgroundColor: colors[3],
                                      mini: isTablet ? false : true,
                                      onPressed: () {
                                        action3();
                                      },
                                      elevation: 0,
                                      child: const Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              action2();
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadeColors[4].withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: colors[4],
                                      ),
                                      width: isTablet ? 260 : 160,
                                      height: isTablet ? 40 : 30,
                                      child: Center(
                                          child: Text(
                                        "Text Recognition Note".tr(),
                                        style: const TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                  Container(
                                    width: isTablet ? 60 : 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: shadeColors[4].withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: FloatingActionButton(
                                      backgroundColor: colors[4],
                                      mini: isTablet ? false : true,
                                      onPressed: () {
                                        action2();
                                      },
                                      elevation: 0,
                                      child: const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              action1();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: shadeColors[1].withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: colors[1],
                                    ),
                                    width: isTablet ? 160 : 100,
                                    height: isTablet ? 40 : 30,
                                    child: Center(
                                        child: Text(
                                      "Text Note".tr(),
                                      style: const TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                                Container(
                                  width: isTablet ? 60 : 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadeColors[1].withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: FloatingActionButton(
                                    backgroundColor: colors[1],
                                    mini: isTablet ? false : true,
                                    onPressed: () {
                                      action1();
                                    },
                                    elevation: 0,
                                    child: const Icon(
                                      Icons.sticky_note_2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        width: isTablet ? 344 : 224,
                      ),
              )),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: openFab ? shadeColors[afterTap].withOpacity(0.3) : shadeColors[main].withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: openFab ? colors[afterTap] : colors[main],
              splashColor: openFab ? colors[main] : colors[afterTap],
              onPressed: () {
                openFab = !openFab;
                setState(() {});
              },
              elevation: 0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
