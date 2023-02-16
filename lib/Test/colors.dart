import 'package:flutter/material.dart';

class ColorsTest extends StatefulWidget {
  const ColorsTest({Key? key}) : super(key: key);

  @override
  State<ColorsTest> createState() => _ColorsTestState();
}

// This Page is used to test material 3 colors
class _ColorsTestState extends State<ColorsTest> {
  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: theme.surfaceVariant.withOpacity(0.6),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.primary,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.secondary,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.tertiary,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.error,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.background,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.surfaceVariant,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onPrimary,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onSecondary,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onTertiary,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onError,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onBackground,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onSurfaceVariant,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.primaryContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.secondaryContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.tertiaryContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.errorContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.surface,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.outline,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onPrimaryContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onSecondaryContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onTertiaryContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onErrorContainer,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.onSurface,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.outline,
                )
              ],
            ),
          ],
        ));
  }
}
