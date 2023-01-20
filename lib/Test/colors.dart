import 'package:flutter/material.dart';

class ColorsTest extends StatefulWidget {
  const ColorsTest({Key? key}) : super(key: key);

  @override
  State<ColorsTest> createState() => _ColorsTestState();
}

class _ColorsTestState extends State<ColorsTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.background,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onTertiary,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onError,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.onSurface,
            ),CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.outline,)
          ],
        ),
      ],)
    );
  }
}
