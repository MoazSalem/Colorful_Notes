import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BottomControls extends StatelessWidget {
  final PageController controller;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const BottomControls({
    super.key,
    required this.controller,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Skip'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: theme.secondary,
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: 4,
            effect: WormEffect(
              dotHeight: 5,
              dotWidth: 10,
              spacing: 5,
              activeDotColor: theme.primary,
            ),
          ),
          TextButton(
            onPressed: onNext,
            child: Text(
              'Next'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
