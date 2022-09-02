import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Screens/SideBar/Info.dart';
import 'package:notes/Screens/SideBar/Notes.dart';
import 'package:notes/Screens/SideBar/NotesTablet.dart';
import 'package:notes/Screens/SideBar/Settings.dart';
import 'package:notes/Screens/SideBar/VoiceNotes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

late Database database;
List<Map> notesMap = [];
List<Color> colors = [
  Colors.amber,
  Color(0xfff77b85),
  Color(0xffff8b34),
  Color(0xff66c6c2),
  Color(0xfff169a7),
];
int currentIndex = 0;
bool loading = true;
bool showDate = true;
bool showShadow = true;
GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> page = [
    Builder(
      builder: (context) {
        return MediaQuery.of(context).size.shortestSide > 600
            ? MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
                child: HomePageT())
            : MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: HomePage());
      },
    ),
    const VoiceNotesPage(),
    const SettingsPage(),
    const InfoPage(),
  ];

  Widget SideBar() {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  const SizedBox(
                    height: 65,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(0);
                      },
                      icon: currentIndex != 0
                          ? const Icon(
                              Icons.text_snippet_outlined,
                              color: Colors.amber,
                              size: 26,
                            )
                          : const Icon(
                              Icons.text_snippet,
                              color: Colors.amber,
                              size: 30,
                            )),
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(1);
                      },
                      icon: currentIndex != 1
                          ? const Icon(
                              Icons.keyboard_voice_outlined,
                              color: Color(0xfff77b85),
                              size: 30,
                            )
                          : const Icon(
                              Icons.keyboard_voice,
                              color: Color(0xfff77b85),
                              size: 30,
                            )),
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                      onPressed: () {
                        onIndexChanged(2);
                      },
                      icon: currentIndex != 2
                          ? const Icon(
                              Icons.settings_outlined,
                              color: Color(0xffff8b34),
                              size: 30,
                            )
                          : const Icon(
                              Icons.settings,
                              color: Color(0xffff8b34),
                              size: 30,
                            )),
                ],
              )),
          Expanded(
            child: IconButton(
                onPressed: () {
                  onIndexChanged(3);
                },
                icon: currentIndex != 3
                    ? const Icon(
                        Icons.info_outline,
                        color: Color(0xff66c6c2),
                        size: 30,
                      )
                    : const Icon(
                        Icons.info,
                        color: Color(0xff66c6c2),
                        size: 30,
                      )),
          )
        ],
      ),
    );
  }

  startPage() async {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: AdaptiveTheme.of(context).brightness,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness:
              AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarColor: Theme.of(context).cardColor,
        ),
        child: Scaffold(
          key: scaffoldKey,
          body: Row(
            children: [
              SideBar(),
              Container(
                height: double.infinity,
                width: 1,
                color: Theme.of(context).highlightColor.withOpacity(0.15),
              ), // Divider
              Expanded(
                  flex: 5,
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FutureBuilder(
                          future: startDatabase(),
                          builder: (context, snapshot) => page[currentIndex],
                        ))
            ],
          ),
        ));
  }
}

Widget divider() {
  return Divider(
    height: 30,
    color:
        Theme.of(scaffoldKey.currentContext!).highlightColor.withOpacity(0.3),
  );
}

Widget customAppBar(String title, [Widget? leading]) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 10, top: 42),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: leading == null ? Container() : leading,
            )
          ],
        ),
      ),
      divider(),
    ],
  );
}

Future<void> startDatabase() async {
  await openDatabase('notes.db', version: 1, onCreate: (db, version) async {
    print("db created");
    await db.execute(
        'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, time Text, cindex INTEGER,edited Text)');
  }, onOpen: (db) async {
    print("db opened");
  }).then((value) => database = value);
  await refreshDatabase();
}

Future<void> refreshDatabase() async {
  await getDatabaseItems(database);
}

Future<void> destroyDatabase() async {
  await deleteDatabase('notes.db');
  await refreshDatabase();
}

Future<void> insertToDatabase(
    {required String title,
    required String content,
    required int index,
    required String time}) async {
  await database.transaction((txn) async {
    txn
        .rawInsert(
            'INSERT INTO Notes(title, content, cindex, time, edited) VALUES("$title", "$content", "$index","$time","no")')
        .then((value) {
      print('inserted: $value');
    });
  });
  await refreshDatabase();
}

Future<void> getDatabaseItems(database) async {
  List<Map> list = await database.rawQuery('SELECT * FROM Notes');
  notesMap = await list;
}

Future<void> editDatabaseItem(
    {required String title,
    required String content,
    required String time,
    required int index,
    required String title2}) async {
  int count = await database.rawUpdate(
      'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, edited = ? WHERE title = ?',
      ['$title2', '$content', '$time', '$index', 'yes', '$title']);
  print('updated: $count');
  await refreshDatabase();
  await refreshDatabase();
}

Future<void> deleteFromDatabase({required int id}) async {
  int count =
      await database.rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);
  assert(count == 1);
  await refreshDatabase();
}
