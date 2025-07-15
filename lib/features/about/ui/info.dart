import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/shared_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomAppbar(title: "Info".tr(), top: 65, locale: 'en'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    children: <TextSpan>[
                      TextSpan(text: "I1".tr()),
                      TextSpan(
                        text: "I2".tr(),
                        style: TextStyle(color: AppConsts.lightColors[2]),
                      ),
                      TextSpan(text: "I3".tr()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    children: <TextSpan>[
                      TextSpan(text: "I6".tr()),
                      TextSpan(
                        text: "I7".tr(),
                        style: TextStyle(color: AppConsts.lightColors[1]),
                      ),
                      TextSpan(text: "I8".tr()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _launchUrl(),
                  child: Text(
                    "Click here to Check The App on Github.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: theme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(AppConsts.gitHubLink))) {
      throw 'Could not launch link';
    }
  }
}
