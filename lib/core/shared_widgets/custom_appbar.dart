import 'package:flutter/material.dart';

import 'custom_divider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    required this.top,
    this.leading,
    required this.locale,
  });
  final String title;
  final String locale;
  final double top;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: locale == 'en' ? 20 : 0,
            right: locale == 'en' ? 0 : 20,
            bottom: 10,
            top: top,
          ),
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
                padding: const EdgeInsets.only(right: 5),
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
