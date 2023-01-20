import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes/Widgets/notes.dart';

Widget customFab(BuildContext context, bool openFab, colors, shadeColors, bool hide, int main, int afterTap, action1, action2) {
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
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.surfaceVariant,
                                      ),
                                      width: isTablet ? 160 : 100,
                                      height: isTablet ? 50 : 40,
                                      child: Center(
                                          child: Text(
                                        "Voice Note".tr(),
                                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                      )),
                                    ),
                                  ),
                                  Container(
                                    width: isTablet ? 60 : 40,
                                    child: FloatingActionButton(
                                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                      mini: isTablet ? false : true,
                                      onPressed: () {
                                        action2();
                                      },
                                      elevation: 0,
                                      child: Icon(
                                        Icons.mic,
                                        color: Theme.of(context).colorScheme.primary,
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
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context).colorScheme.surfaceVariant, //colors[1],
                                    ),
                                    width: isTablet ? 160 : 100,
                                    height: isTablet ? 50 : 40,
                                    child: Center(
                                        child: Text(
                                      "Text Note".tr(),
                                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                    )),
                                  ),
                                ),
                                Container(
                                  width: isTablet ? 60 : 40,
                                  child: FloatingActionButton(
                                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                    //colors[1],
                                    mini: isTablet ? false : true,
                                    onPressed: () {
                                      action1();
                                    },
                                    elevation: 0,
                                    child: Icon(
                                      Icons.sticky_note_2,
                                      color: Theme.of(context).colorScheme.primary,
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
          Container(
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              //openFab ? colors[afterTap] : colors[main],
              //splashColor: Theme.of(context).colorScheme.primaryContainer,
              //openFab ? colors[main] : colors[afterTap],
              onPressed: () {
                openFab = !openFab;
                setState(() {});
              },
              elevation: 0,

              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.surfaceVariant, //white
              ),
            ),
          ),
        ],
      ),
    ),
  );
}