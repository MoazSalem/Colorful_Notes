import 'package:colorful_notes/core/providers/settings_notifier.dart';
import 'package:colorful_notes/features/notes/ui/screens/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final theme = Theme.of(context).colorScheme;
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
            child: Consumer(
              builder: (context, ref, child) {
                final settings = ref.watch(settingsNotifierProvider);
                return settings.when(
                  data: (settings) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      'START',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.onPrimary,
                      ),
                    ),
                    onPressed: () async {
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .updateSettings(
                            settings.copyWith(firstLaunch: false),
                          );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                  ),
                  error: (error, stackTrace) => const Text('Error'),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            ),
          ),
      ],
    );
  }
}
