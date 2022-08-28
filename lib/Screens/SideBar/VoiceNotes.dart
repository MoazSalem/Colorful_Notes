import 'package:flutter/material.dart';

class VoiceNotesPage extends StatefulWidget {
  const VoiceNotesPage({Key? key}) : super(key: key);

  @override
  State<VoiceNotesPage> createState() => _VoiceNotesPageState();
}

class _VoiceNotesPageState extends State<VoiceNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "To be Implemented in the future",
          style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
