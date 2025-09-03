import 'package:flutter/material.dart';

class DynamicMaxLinesText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextOverflow overflow;

  const DynamicMaxLinesText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final effectiveDirection = textDirection ?? Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate line height
        final lineHeight =
            (defaultStyle.fontSize ?? 14) * (defaultStyle.height ?? 1.4);

        // Available lines based on height
        final maxLines = (constraints.maxHeight / lineHeight).floor();

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth),
          child: Text(
            text,
            style: defaultStyle,
            textAlign: textAlign,
            textDirection: effectiveDirection,
            maxLines: maxLines > 0 ? maxLines : 1,
            overflow: overflow,
            softWrap: true,
          ),
        );
      },
    );
  }
}
