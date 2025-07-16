import 'package:colorful_notes/features/onboarding/ui/widgets/bottom_controls.dart';
import 'package:colorful_notes/features/onboarding/ui/widgets/language_switcher.dart';
import 'package:colorful_notes/features/onboarding/ui/widgets/onboarding_page_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final controller = PageController();
  bool isLastPage = false;
  bool isArabic = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
      context.setLocale(Locale(isArabic ? 'ar' : 'en'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: isArabic ? Alignment.topLeft : Alignment.topRight,
            children: [
              PageView(
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 3;
                  });
                },
                controller: controller,
                // Removed const to allow pages to rebuild on language change
                children: [
                  OnboardingPageWidget(
                    lottieAsset: 'assets/animations/hello.json',
                    titleKey: 'T1',
                    bodyKey: 'B1',
                  ),
                  OnboardingPageWidget(
                    lottieAsset: 'assets/animations/notes.json',
                    titleKey: 'T2',
                    bodyKey: 'B2',
                  ),
                  OnboardingPageWidget(
                    lottieAsset: 'assets/animations/voice.json',
                    titleKey: 'T3',
                    bodyKey: 'B3',
                  ),
                  OnboardingPageWidget(
                    lottieAsset: 'assets/animations/start.json',
                    titleKey: 'T5',
                    bodyKey: '',
                    isLastPage: true,
                  ),
                ],
              ),
              LanguageSwitcher(isArabic: isArabic, onToggle: _toggleLanguage),
            ],
          ),
          bottomNavigationBar: isLastPage
              ? null
              : BottomControls(
                  controller: controller,
                  onSkip: () => controller.jumpToPage(3),
                  onNext: () => controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
        ),
      ),
    );
  }
}
