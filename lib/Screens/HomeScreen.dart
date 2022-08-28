import 'package:flutter/material.dart';
import 'package:notes/Screens/Info.dart';
import 'package:notes/Screens/SideBar/Notes.dart';
import 'package:notes/Screens/SideBar/Settings.dart';
import 'package:notes/Screens/SideBar/VoiceNotes.dart';
import 'package:sqflite/sqflite.dart';

late final Color TheColor;
late Database database;
List<Map> notesMap = [];
List <Color> colors = [ Colors.amber, Color(0xfff77b85), Color(0xffff8b34), Color(0xff66c6c2),Color(0xfff169a7),];
int currentIndex = 0;
bool loading = true;
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> page = [
    const HomePage(),
    const VoiceNotesPage(),
    const SettingsPage(),
    const InfoPage(),
  ];

  startPage() async{
    await startDatabase();
    await Future.delayed(Duration(seconds: 1));
    loading = false;
    setState(() {});
  }

  onIndexChanged(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    startPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 65,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(0);
                        setState(() {
                        });
                      },
                      icon: currentIndex != 0 ? const Icon(
                        Icons.text_snippet_outlined,
                        color: Colors.white,
                      ) : const Icon(Icons.text_snippet,color: Colors.white,)),
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(1);
                        setState(() {
                        });
                      },
                      icon: currentIndex != 1 ? const Icon(
                  Icons.keyboard_voice_outlined,
                    color: Colors.white,
                  ) : const Icon(Icons.keyboard_voice,color: Colors.white,)), const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(2);
                        setState(() {
                        });
                      },
                      icon: currentIndex != 2 ? const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                      ) : const Icon(Icons.settings,color: Colors.white,)), const SizedBox(
                    height: 420,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(3);
                        setState(() {
                        });
                      },
                      icon: currentIndex != 3 ? const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ) : const Icon(Icons.info,color: Colors.white,))
                ],
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child:loading? Center(child: CircularProgressIndicator(),) : FutureBuilder(future: startDatabase() ,builder: (context, snapshot) => page[currentIndex],))
        ],
      ),
    );
  }
}
Future<void> startDatabase() async {
  openDatabase('notes.db', version: 1, onCreate: (db, version) async {
    print("db created");
    await db.execute(
        'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, time Text, cindex INTEGER)');
  }, onOpen: (db) async{
    await getDatabaseItems(db);
    print("db opened");
  }).then((value) => database = value);
}

Future<void> destroyDatabase() async {
  await deleteDatabase('notes.db');
  startDatabase();
  getDatabaseItems(database).then((value) => database = value as Database);
}

Future<void> insertToDatabase({required String title,
  required String content,
  required int index,
  required String time}) async {
  await database.transaction((txn) async {
    txn
        .rawInsert(
        'INSERT INTO Notes(title, content, cindex, time) VALUES("$title", "$content", "$index","$time")')
        .then((value) {
      print('inserted: $value');
      getDatabaseItems(database).then((value) =>
      database = value as Database);
    });
  });
}

Future<List<Map>> getDatabaseItems(database) async {
  List<Map> list = await database.rawQuery('SELECT * FROM Notes');
  return notesMap = await list;
}

Future<void> editDatabaseItem({required String title,
  required String content,
  required String time,
  required int index,
  required String title2}) async {
  int count = await database.rawUpdate(
      'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ? WHERE title = ?',
      ['$title2', '$content', '$time', '$index','$title']);
  print('updated: $count');
  getDatabaseItems(database).then((value) => database = value as Database);
}

Future<void> deleteFromDatabase({required int id}) async {
  int count =
  await database.rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);
  assert(count == 1);
  getDatabaseItems(database).then((value) => database = value as Database);
}