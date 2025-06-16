import 'package:colorful_notes/features/home/ui/home_screen.dart';
import 'package:colorful_notes/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String lottieAsset;
  final String titleKey;
  final String bodyKey;
  final bool isLastPage;

  const OnboardingPageWidget({
    super.key,
    required this.lottieAsset,
    required this.titleKey,
    required this.bodyKey,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(lottieAsset, height: 300),
        const SizedBox(height: 40),
        Text(
          titleKey.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            bodyKey.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (isLastPage)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'START',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onPressed: () async {
                C.box.put('showHome', true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
            ),
          ),
      ],
    );
  }
}
