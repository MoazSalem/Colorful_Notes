import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ColorBar extends StatelessWidget {
  const ColorBar({
    super.key,
    required this.colors,
    required this.textColor,
    required this.chosenIndex,
    required this.textColorIndex,
    required this.changeTextColor,
    required this.setCustomColor,
    required this.semiTransparentColor,
    required this.pickerColor,
    required this.setIndex,
  });
  final List<Color> colors;
  final Color textColor;
  final Color semiTransparentColor;
  final Color pickerColor;
  final int chosenIndex;
  final int textColorIndex;
  final void Function() changeTextColor;
  final void Function() setCustomColor;
  final void Function(int) setIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, index) => index == 0
            ? Column(
                children: [
                  GestureDetector(
                    onTap: changeTextColor,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "Ab".tr(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: setCustomColor,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: chosenIndex == 99
                            ? textColor
                            : semiTransparentColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: pickerColor,
                            ),
                            Text(
                              "#",
                              style: TextStyle(color: textColor, fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setIndex(index),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: chosenIndex == index
                            ? textColor
                            : semiTransparentColor,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: colors[index],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => setIndex(index),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: chosenIndex == index
                        ? textColor
                        : semiTransparentColor,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: colors[index],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
