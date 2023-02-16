// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:notes/Data/colors.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/SideBar/notes.dart';
import 'package:notes/Screens/SideBar/voice_notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

// import 'package:path/path.dart' as path;
// import 'package:path/path.dart';
// import 'package:external_path/external_path.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  late Database database;
  late Box box;
  late int viewIndex;
  late int viewIndexN;
  late int viewIndexV;
  late int adCounter;
  late int sbIndex;
  late int fabIndex;
  late double width;
  late Directory appDir;

  // late List<String> extDir;
  late bool isBlack;
  late bool showDate;
  late bool showShadow;
  late bool showEdited;
  late bool darkColors;
  late bool isDarkMode;
  late bool colorful;
  late bool harmonizeColor;
  List<Map> allNotesMap = [];
  List<Map> voiceMap = [];
  List<Map> notesMap = [];
  List<Map> searchedALL = [];
  List<Map> searchedNotes = [];
  List<Map> searchedVoice = [];
  late List<Color> colors;
  late List<Color> lHColors;
  late List<Color> dHColors;
  List<Color> shadeColors = darkerColors;
  int currentIndex = 0;
  bool loading = true;
  late String openPage;
  late String lang;
  bool isTablet = getDeviceType() == 'tablet' ? true : false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var brightness = SchedulerBinding.instance.window.platformBrightness;

  // If themeMode is null it follows system theme
  var themeMode;
  String currentTheme = "System";

  static NotesBloc get(context) => BlocProvider.of(context);

  NotesBloc({required Box gBox}) : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {});
    box = gBox;
  }

  startPage() async {
    await startDatabase();
    await localPath();
    await getHomePage();
    await Future.delayed(const Duration(seconds: 1));
    loading = false;
    emit(AppInitial());
  }

  onIndexChanged(int index) {
    currentIndex = index;
    emit(NavigationBarChanged());
  }

  onCreateNote() {
    searchNotes(searchC.text);
    searchVoice(searchVC.text);
    searchHome(searchAC.text);
    emit(NoteCreate());
  }

  onSearch() {
    emit(OnSearched());
  }

  onViewChanged() {
    emit(ViewChanged());
  }

  onColorChanged() {
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

  onDurationChanged() {
    emit(onDurationChanged());
  }

  onPositionChanged() {
    emit(onPositionChanged());
  }

  onChanged() {
    emit(OnChanged());
  }

  onDelete() {
    searchNotes(searchC.text);
    searchVoice(searchVC.text);
    searchHome(searchAC.text);
    emit(OnChanged());
  }

  localPath() async {
    appDir = await getApplicationDocumentsDirectory();
    // extDir = await ExternalPath.getExternalStorageDirectories();
  }

  createVoiceFolder() async {
    Directory voice = Directory("${appDir.path}/Voice");
    if ((await voice.exists())) {
      if (kDebugMode) {
        print("exist");
      }
    } else {
      if (kDebugMode) {
        print("not exist");
      }
      await Permission.storage.request().isGranted;

      // Either the permission was already granted before or the user just granted it.
      await voice.create(recursive: true);
    }
  }

  getHomePage() async {
    openPage = box.get('Pages') ?? 'Home';
    openPage == 'Home'
        ? currentIndex = 0
        : openPage == 'Text'
            ? currentIndex = 1
            : currentIndex = 2;
  }

  getScreenWidth(context) {
    width = MediaQuery.of(context).size.width;
  }

  Future getStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (kDebugMode) {
      print('status $status');
    }
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else if (status.isDenied) {
      if (kDebugMode) {
        print('Permission Denied');
      }
    }
  }

  // Future getAllStoragePermission() async {
  //   PermissionStatus status = await Permission.storage.request();
  //   PermissionStatus status1 = await Permission.accessMediaLocation.request();
  //   PermissionStatus status2 = await Permission.manageExternalStorage.request();
  //   if (kDebugMode) {
  //     print('status $status -> $status1 -> $status2');
  //   }
  //   if (status.isGranted && status2.isGranted) {
  //     return true;
  //   } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
  //     await openAppSettings();
  //   } else if (status.isDenied) {
  //     if (kDebugMode) {
  //       print('Permission Denied');
  //     }
  //   }
  // }

  Future deleteFile(location) async {
    try {
      await File(location).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  TextDirection getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  showDeleteDialog(BuildContext context, List<Map> notes, int index) {
    return Dialogs.materialDialog(
        msg: "msg".tr(),
        title: "DeleteN".tr(),
        color: Theme.of(context).cardColor,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'Cancel'.tr(),
            iconData: Icons.cancel_outlined,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
          IconsButton(
            onPressed: () async {
              notes[index]["type"] == 1
                  ? {
                      await deleteFile(notes[index]["content"]),
                      await deleteFromDatabase(id: notes[index]["id"]),
                    }
                  : {
                      await deleteFromDatabase(id: notes[index]["id"]),
                    };
              Navigator.of(context).pop();
              onDelete();
            },
            text: 'Delete'.tr(),
            iconData: Icons.delete,
            color:
                colors[notes[index]['cindex']].harmonizeWith(Theme.of(context).colorScheme.primary),
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ]);
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
    List<String> translate = parsedDate.split(' ');
    parsedDate = lang == 'en' ? parsedDate : "${translate[1]} ${translate[0].tr()}";
    return parsedDate;
  }

  void searchHome(String query) {
    final searched = allNotesMap.where((note) {
      final title = note['title'].toString().toLowerCase();
      final content = note['content'].toString().toLowerCase();
      return note['type'] == 0
          ? title.contains(query.toLowerCase()) || content.contains(query.toLowerCase())
          : title.contains(query.toLowerCase());
    }).toList();
    searchedALL = searched;
    onSearch();
  }

  void harmonizeColors(BuildContext context) {
    List<Color> hColors = [];
    for (var color in lightColors) {
      hColors.add(color.harmonizeWith(Theme.of(context).colorScheme.primary));
    }
    lHColors = hColors;
    for (var color in darkerColors) {
      hColors.add(color.harmonizeWith(Theme.of(context).colorScheme.primary));
    }
    dHColors = hColors;
  }

  void searchNotes(String query) {
    final searched = notesMap.where((note) {
      final title = note['title'].toString().toLowerCase();
      final content = note['content'].toString().toLowerCase();
      return title.contains(query.toLowerCase()) || content.contains(query.toLowerCase());
    }).toList();
    searchedNotes = searched;
    onSearch();
  }

  void searchVoice(String query) {
    final searched = voiceMap.where((note) {
      final title = note['title'].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
    searchedVoice = searched;
    onSearch();
  }

  Future<void> startDatabase() async {
    await openDatabase('notes.db', version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, time Text, cindex INTEGER, tindex INTEGER, type INTEGER, edited Text, layout INTEGER, extra Text)');
    }, onOpen: (db) async {})
        .then((value) => database = value);
    isDarkMode = brightness == Brightness.dark;
    viewIndex = box.get('viewIndex') ?? 0;
    viewIndexN = box.get('viewIndexN') ?? 0;
    viewIndexV = box.get('viewIndexV') ?? 0;
    adCounter = box.get('adCounter') ?? 0;
    sbIndex = box.get('sbIndex') ?? 0;
    fabIndex = box.get('fabIndex') ?? 0;
    isBlack = box.get('isBlack') ?? false;
    showDate = box.get('showDate') ?? true;
    showShadow = box.get('showShadow') ?? false;
    showEdited = box.get('showEdit') ?? true;
    colorful = box.get('colorful') ?? true;
    darkColors = box.get('darkColors') ?? false;
    harmonizeColor = box.get('harmonizeColor') ?? false;
    colors = darkColors ? darkerColors : lightColors;
    var c = box.get('themeMode') ?? 2;
    c == 0
        ? {themeMode = ThemeMode.light, currentTheme = "Light"}
        : c == 1
            ? {themeMode = ThemeMode.dark, currentTheme = "Dark"}
            : {themeMode = null, currentTheme = "System"};
    // colors = darkColors
    //     ? harmonizeColor
    //     ? dHColors
    //     : darkerColors
    //     : harmonizeColor
    //     ? lHColors
    //     : lightColors;
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
      required int layout,
      int? type = 0,
      int? tIndex = 0,
      String? edited = 'no'}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Notes(title, content, cindex, tindex, type, time, edited ,layout, extra) VALUES("$title", "$content", "$index", "$tIndex", "$type","$time","$edited","$layout","")')
          .then((value) {});
    });
    await refreshDatabase();
  }

  Future<void> getDatabaseItems(database) async {
    List<Map> list = await database.rawQuery('SELECT * FROM Notes');
    allNotesMap = list;
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
      required String title,
      required int layout,
      int? tIndex = 0,
      String? edited = 'yes'}) async {
    await database.rawUpdate(
        'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, tindex = ?, type = ?, edited = ?, layout = ?, extra = ? WHERE id = ?',
        [title, content, time, index, tIndex, type, edited, layout, "", id]);
    await refreshDatabase();
  }

  Future<void> deleteFromDatabase({required int id}) async {
    int count = await database.rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);
    assert(count == 1);
    await refreshDatabase();
  }

  Widget divider(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Divider(
        thickness: 1,
        color: Theme.of(context)
            .colorScheme
            .outline
            .withOpacity(0.2), //Theme.of(context).highlightColor.withOpacity(0.3),
      ),
    );
  }

  Widget customAppBar(BuildContext context, String title, double top, [Widget? leading]) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: lang == 'en'
                  ? isTablet
                      ? 40
                      : 20
                  : 0,
              right: lang == 'en'
                  ? 0
                  : isTablet
                      ? 40
                      : 20,
              bottom: 10,
              top: top),
          child: Stack(
            alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: leading ?? Container(),
              )
            ],
          ),
        ),
        divider(context),
      ],
    );
  }

// void copyDirectory(Directory source, Directory destination) => source.listSync(recursive: false).forEach((var entity) {
//       if (entity is Directory) {
//         var newDirectory = Directory(path.join(destination.absolute.path, path.basename(entity.path)));
//         newDirectory.createSync();
//
//         copyDirectory(entity.absolute, newDirectory);
//       } else if (entity is File) {
//         entity.copySync(path.join(destination.path, path.basename(entity.path)));
//       }
//     });

// backUp() async {
//   await getAllStoragePermission();
//   final dbFolder = await getDatabasesPath();
//   File source1 = File('$dbFolder/notes.db');
//   File source2 = File('/data/user/0/com.moazsalem.notes/shared_prefs/FlutterSharedPreferences.xml');
//   File source3 = File('${appDir.path}/Voice');
//   Directory dbBackup = Directory("${extDir[0]}/Download/Colorful Notes/backup/Database");
//   Directory voBackup = Directory("${extDir[0]}/Download/Colorful Notes/backup/.VoiceNotes");
//   Directory spBackup = Directory("${extDir[0]}/Download/Colorful Notes/backup/Shared_Preference");
//   if ((dbBackup.existsSync()) && (voBackup.existsSync()) && (spBackup.existsSync())) {
//     if (kDebugMode) {
//       print("Path exist");
//     }
//   } else {
//     if (kDebugMode) {
//       print("Path doesn't exist");
//     }
//     await dbBackup.create(recursive: true);
//     await voBackup.create(recursive: true);
//     await spBackup.create(recursive: true);
//   }
//   String newPath = "${dbBackup.path}/notes.db";
//   await source1.copy(newPath);
//   if (kDebugMode) {
//     print("Successfully Copied DB");
//   }
//   newPath = "${spBackup.path}/FlutterSharedPreferences.xml";
//   await source2.copy(newPath);
//   if (kDebugMode) {
//     print("Successfully Copied FlutterSharedPreferences.xml");
//   }
//   if (Directory(source3.path).existsSync()) {
//     if (kDebugMode) {
//       print("Voice exist");
//       }
//     copyDirectory(Directory(source3.path), Directory(voBackup.path));
//     if (kDebugMode) {
//       print("Successfully Copied Voice Notes");
//     }
//   } else {
//     if (kDebugMode) {
//       print("Voice doesn't exist");
//     }
//   }
// }
//
// restore() async {
//   await getAllStoragePermission();
//   final dbFolder = await getDatabasesPath();
//   String source1 = '$dbFolder/notes.db';
//   String source2 = '/data/user/0/com.moazsalem.notes/shared_prefs/FlutterSharedPreferences.xml';
//   String source3 = '${appDir.path}/Voice';
//   Directory dbBackup = Directory("${extDir[0]}/Download/Colorful Notes/backup/Database");
//   Directory voBackup = Directory("${extDir[0]}/Download/Colorful Notes/backup/.VoiceNotes");
//   Directory spBackup = Directory("${extDir[0]}/Download/Colorful Notes/backup/Shared_Preference");
//   if ((dbBackup.existsSync()) && (voBackup.existsSync()) && (spBackup.existsSync())) {
//     if (kDebugMode) {
//       print("Path exist");
//       if ((Directory(source3).existsSync())) {
//         if (kDebugMode) {
//           print("Voice exist");
//           await Directory(source3).delete(recursive: true);
//           await Directory(source3).create(recursive: true);
//         }
//       } else {
//         if (kDebugMode) {
//           print("Voice doesn't exist");
//         }
//         await Directory(source3).create(recursive: true);
//       }
//     }
//   } else {
//     if (kDebugMode) {
//       print("Path doesn't exist");
//     }
//   }
//   File db = File("${dbBackup.path}/notes.db");
//   await db.copy(source1);
//   if (kDebugMode) {
//     print("Successfully Copied DB");
//   }
//   File sp = File("${spBackup.path}/FlutterSharedPreferences.xml");
//   await sp.copy(source2);
//   if (kDebugMode) {
//     print("Successfully Copied FlutterSharedPreferences.xml");
//   }
//   copyDirectory(Directory(voBackup.path), Directory(source3));
//   if (kDebugMode) {
//     print("Successfully Copied Voice Notes");
//   }
//   startDatabase();
// }
//
// bDialog(BuildContext context) {
//   return Dialogs.materialDialog(msg: "m2".tr(), title: "Backup".tr(), color: Theme.of(context).cardColor, context: context, actions: [
//     IconsOutlineButton(
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//       text: 'Cancel'.tr(),
//       iconData: Icons.cancel_outlined,
//       textStyle: const TextStyle(color: Colors.grey),
//       iconColor: Colors.grey,
//     ),
//     IconsButton(
//       onPressed: () async {
//         await backUp();
//         Navigator.of(context).pop();
//         onDelete();
//         SnackBar snackBar = SnackBar(
//           content: Text('Backup Complete'.tr()),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       },
//       text: 'Backup'.tr(),
//       iconData: Icons.backup_outlined,
//       color: colors[0],
//       textStyle: const TextStyle(color: Colors.white),
//       iconColor: Colors.white,
//     ),
//   ]);
// }
//
// rDialog(BuildContext context) {
//   return Dialogs.materialDialog(msg: "m3".tr(), title: "Restore".tr(), color: Theme.of(context).cardColor, context: context, actions: [
//     IconsOutlineButton(
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//       text: 'Cancel'.tr(),
//       iconData: Icons.cancel_outlined,
//       textStyle: const TextStyle(color: Colors.grey),
//       iconColor: Colors.grey,
//     ),
//     IconsButton(
//       onPressed: () async {
//         await restore();
//         Navigator.of(context).pop();
//         onDelete();
//         SnackBar snackBar = SnackBar(
//           content: Text('Restore Complete'.tr()),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       },
//       text: 'Yes'.tr(),
//       iconData: Icons.restore,
//       color: colors[0],
//       textStyle: const TextStyle(color: Colors.white),
//       iconColor: Colors.white,
//     ),
//   ]);
// }
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 750 ? 'phone' : 'tablet';
}

// Directory? appDocumentsDirectory = await getExternalStorageDirectory();
// print(appDocumentsDirectory);
