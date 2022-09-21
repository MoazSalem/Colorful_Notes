import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  late Database database;
  List<Map> allNotesMap = [];
  List<Map> voiceMap = [];
  List<Map> notesMap = [];
  List<Color> colors = [
    Colors.amber,
    Color(0xfff77b85),
    Color(0xffff8b34),
    Color(0xff66c6c2),
    Color(0xfff169a7),
  ];
  int currentIndex = 0;
  int chosenIndex = 0;
  late int viewIndex;
  bool loading = true;
  late Directory appDir;
  late bool showDate;
  late bool showShadow;
  bool isTablet = getDeviceType() == 'tablet' ? true : false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  static NotesBloc get(context) => BlocProvider.of(context);

  NotesBloc() : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  startPage() async {
    await startDatabase();
    await localPath();
    await Future.delayed(Duration(seconds: 1));
    loading = false;
    emit(DatabaseInitial());
  }

  onIndexChanged(int index) {
    currentIndex = index;
    emit(NavigationBarChanged());
  }

  onCreateNote() {
    emit(NoteCreate());
  }

  onSearch() {
    emit(Searched());
  }

  onViewChanged() {
    emit(ViewChanged());
  }

  ColorChanged(int Index) {
    chosenIndex = Index;
    emit(ColorsChanged());
  }

  onRecord() {
    emit(OnRecord());
  }

  prefsChanged() {
    emit(PrefsChanged());
  }

  audioPlayed() {
    emit(AudioPlayed());
  }

  onChanged() {
    emit(OnChanged());
  }

  localPath() async {
    appDir = await getApplicationDocumentsDirectory();
  }

  Future getStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    PermissionStatus status1 = await Permission.accessMediaLocation.request();
    PermissionStatus status2 = await Permission.manageExternalStorage.request();
    print('status $status   -> $status2');
    if (status.isGranted && status2.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
      await openAppSettings();
    } else if (status.isDenied) {
      print('Permission Denied');
    }
  }
  Future deleteFile(location) async {
    try {
      await File(location).delete();
    } catch (e) {
    }
  }

  int calculateDifference(String stringDate) {
    var date = DateTime.parse(stringDate);
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String parseDate(String stringDate) {
    var date = DateTime.parse(stringDate);
    String parsedDate = DateFormat.MMMMd().format(date);
    return parsedDate;
  }

  Future<void> startDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    await openDatabase('notes.db', version: 1, onCreate: (db, version) async {
      print("db created");
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, time Text, cindex INTEGER, tindex INTEGER, type INTEGER,edited Text)');
    }, onOpen: (db) async {
      print("db opened");
    }).then((value) => database = value);
    viewIndex = await prefs.getInt('viewIndex') ?? 0;
    showDate = await prefs.getBool('showDate') ?? true;
    showShadow = await prefs.getBool('showShadow') ?? true;
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
      required String time,
      int? type = 0}) async {
    await database.transaction((txn) async {
      int tIndex = 0;
      txn
          .rawInsert(
              'INSERT INTO Notes(title, content, cindex, tindex, type, time, edited) VALUES("$title", "$content", "$index", "$tIndex", "$type","$time","no")')
          .then((value) {
        print('inserted: $value');
      });
    });
    await refreshDatabase();
  }

  Future<void> getDatabaseItems(database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM Notes');
    allNotesMap = await list;
    final searched = allNotesMap.where((note) {
      final type = note['type'];
      return type == 0;
    }).toList();
    notesMap = searched;
    final searched2 = allNotesMap.where((note) {
      final type = note['type'];
      return type == 1;
    }).toList();
    voiceMap = searched2;
  }

  Future<void> editDatabaseItem(
      {required int id,
      required String content,
      required String time,
      required int index,
      required int type,
      required String title2}) async {
    int tIndex = 0;
    int count = await database.rawUpdate(
        'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, tindex = ?, type = ?,edited = ? WHERE id = ?',
        [
          '$title2',
          '$content',
          '$time',
          '$index',
          '$tIndex',
          '$type',
          'yes',
          '$id'
        ]);
    print('updated: $count');
    await refreshDatabase();
  }

  Future<void> deleteFromDatabase({required int id}) async {
    int count =
        await database.rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);
    assert(count == 1);
    await refreshDatabase();
  }

  Widget divider(BuildContext context) {
    return Divider(
      height: 20,
      color: Theme.of(context).highlightColor.withOpacity(0.3),
    );
  }

  Widget customAppBar(BuildContext context, String title, double top,
      [Widget? leading]) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: isTablet ? 40 : 20, bottom: 10, top: top),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: leading == null ? Container() : leading,
              )
            ],
          ),
        ),
        divider(context),
      ],
    );
  }
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}