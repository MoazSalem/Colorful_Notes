import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final Uri _url = Uri.parse('https://github.com/MoazSalem/Colorful_Notes');
  late ColorScheme theme;
  late Color textColor;
  late NotesBloc B;

  @override
  void initState() {
    B = NotesBloc.get(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context).colorScheme;
    textColor = theme.onSurfaceVariant;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: B.isDarkMode ? theme.background : theme.surfaceVariant.withOpacity(0.6),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar("Info".tr(), 65),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                        style: TextStyle(
                            fontSize: B.isTablet ? 30 : 20,
                            fontWeight: FontWeight.w300,
                            color: textColor),
                        children: <TextSpan>[
                          TextSpan(text: "I1".tr()),
                          TextSpan(text: "I2".tr(), style: TextStyle(color: B.colors[2])),
                          TextSpan(text: "I3".tr()),
                        ],
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        style: TextStyle(
                            fontSize: B.isTablet ? 30 : 20,
                            fontWeight: FontWeight.w300,
                            color: textColor),
                        children: <TextSpan>[
                          TextSpan(text: "I6".tr()),
                          TextSpan(text: "I7".tr(), style: TextStyle(color: B.colors[1])),
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
                              fontSize: 20, fontWeight: FontWeight.w300, color: B.colors[5]),
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
