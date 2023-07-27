import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Services/flex_colors/app_color.dart';

// Widget used to change the used AppColor.customSchemes[index] in example 4.
class ThemePopupMenu extends StatelessWidget {
  const ThemePopupMenu({
    super.key,
    required this.schemeIndex,
    required this.onChanged,
    required this.isTablet,
    required this.textColor,
    this.contentPadding,
  });

  final Color textColor;
  final int schemeIndex;
  final bool isTablet;
  final ValueChanged<int> onChanged;

  // Defaults to 16, like ListTile does.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final ColorScheme colorScheme = theme.colorScheme;

    return PopupMenuButton<int>(
      tooltip: '',
      padding: EdgeInsets.zero,
      onSelected: onChanged,
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        for (int i = 0; i < AppColor.customSchemes.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.lens,
                  color: isLight
                      ? AppColor.customSchemes[i].light.primary
                      : AppColor.customSchemes[i].dark.primary,
                  size: 35),
              title: Text(AppColor.customSchemes[i].name),
            ),
          )
      ],
      child: ListTile(
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        title: Text("Current Theme".tr(),
            style: TextStyle(
              color: textColor,
              fontSize: isTablet ? 26 : 22,
              fontWeight: FontWeight.w400,
            )),
        subtitle: Text(
          AppColor.customSchemes[schemeIndex].description,
          style: TextStyle(fontSize: isTablet ? 16 : 12, color: textColor, fontWeight: FontWeight.w300),
        ),
        trailing: Icon(
          Icons.lens,
          color: colorScheme.primary,
          size: isTablet ? 44 : 40,
        ),
      ),
    );
  }
}
