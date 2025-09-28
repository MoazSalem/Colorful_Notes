import 'package:flutter/material.dart';

import 'custom_divider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    required this.top,
    this.leading,
  });
  final String title;
  final double top;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final String locale = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 20, bottom: 10, top: top),
          child: Stack(
            alignment: locale == 'en'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: leading ?? Container(),
              ),
            ],
          ),
        ),
        CustomDivider(),
      ],
    );
  }
}
