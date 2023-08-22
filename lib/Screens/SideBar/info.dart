import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Cubit/notes_cubit.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/main.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final Uri _url = Uri.parse('https://github.com/MoazSalem/Colorful_Notes');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: C.isDark
              ? C.theme.background
              : C.theme.surfaceVariant.withOpacity(0.6),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              C.customAppBar("Info".tr(), 65),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                        style: TextStyle(
                            fontSize: C.isTablet ? 30 : 20,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                        children: <TextSpan>[
                          TextSpan(text: "I1".tr()),
                          TextSpan(text: "I2".tr(), style: TextStyle(color: C.colors[2])),
                          TextSpan(text: "I3".tr()),
                        ],
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        style: TextStyle(
                            fontSize: C.isTablet ? 30 : 20,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                        children: <TextSpan>[
                          TextSpan(text: "I6".tr()),
                          TextSpan(text: "I7".tr(), style: TextStyle(color: C.colors[1])),
                          TextSpan(text: "I8".tr()),
                        ],
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => _launchUrl(),
                        child: Text(
                          "Click here to Check The App on Github.",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300, color: primaryColor),
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
