import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView(children: [Padding(
      padding:
      const EdgeInsets.only(left: 30, bottom: 20, top: 60),
      child: Text(
        "Info",
        style: TextStyle(
            fontSize: 50, fontWeight: FontWeight.bold),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(children: [Text("This app was made by Moaz Salem using flutter to learn new techniques!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
        SizedBox(height: 10,),
        Text("The app uses Sqflite for a local database to store all the notes data.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),],)
    )],),);
  }
}
