import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://github.com/MoazSalem/Colorful_Notes');

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var B = NotesBloc.get(context);
        Color textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        return Scaffold(
          backgroundColor: B.isDarkMode ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context, "Info".tr(), 65),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                        style: TextStyle(fontSize: B.isTablet ? 30 : 20, fontWeight: FontWeight.w300, color: textColor),
                        children: <TextSpan>[
                          TextSpan(text: "I1".tr()),
                          TextSpan(text: "I2".tr(), style: TextStyle(color: B.colors[2].harmonizeWith(Theme.of(context).colorScheme.primary))),
                          TextSpan(text: "I3".tr()),
                        ],
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        style: TextStyle(fontSize: B.isTablet ? 30 : 20, fontWeight: FontWeight.w300, color: textColor),
                        children: <TextSpan>[
                          TextSpan(text: "I6".tr()),
                          TextSpan(text: "I7".tr(), style: TextStyle(color: B.colors[1].harmonizeWith(Theme.of(context).colorScheme.primary))),
                          TextSpan(text: "I8".tr()),
                        ],
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        style: TextStyle(fontSize: B.isTablet ? 30 : 20, fontWeight: FontWeight.w300, color: textColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: "I9".tr(),
                          ),
                          TextSpan(text: "I10".tr(), style: TextStyle(color: B.colors[3].harmonizeWith(Theme.of(context).colorScheme.primary))),
                          TextSpan(text: "I13".tr()),
                        ],
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                         onTap: () => _launchUrl(),
                         child: Text(
                           "Click here to Check The App on Github.",
                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: B.colors[5].harmonizeWith(Theme.of(context).colorScheme.primary)),
                         ),
                       ),
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
