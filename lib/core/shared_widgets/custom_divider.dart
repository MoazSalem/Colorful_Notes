import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Divider(
        thickness: 1,
        color: Theme.of(context).colorScheme.outline.withAlpha(
          45,
        ), //Theme.of(context).highlightColor.withOpacity(0.3),
      ),
    );
  }
}
