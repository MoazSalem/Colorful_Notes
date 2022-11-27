// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:huawei_ml_language/huawei_ml_language.dart';
//import 'package:huawei_ml_text/huawei_ml_text.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/SideBar/notes.dart';
import 'package:notes/Screens/SideBar/voice_notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  late Database database;
  late int viewIndex;
  late int viewIndexN;
  late int viewIndexV;
  late int adCounter;
  late double width;
  late Directory appDir;
  late List<String> extDir;
  late bool showDate;
  late bool showShadow;
  late bool showEdited;
  List<Map> allNotesMap = [];
  List<Map> voiceMap = [];
  List<Map> notesMap = [];
  List<Map> searchedALL = [];
  List<Map> searchedNotes = [];
  List<Map> searchedVoice = [];
  List<Color> colors = [
    Colors.amber,
    const Color(0xfff77b85),
    const Color(0xffff8b34),
    const Color(0xff66c6c2),
    const Color(0xfff169a7),
  ];
  List<Color> shadeColors = [
    const Color(0xffcc9a05),
    const Color(0xffc36169),
    const Color(0xffcc6f29),
    const Color(0xff4b9390),
    const Color(0xffbe5283),
  ];
  int currentIndex = 0;
  bool loading = true;
  late String openPage;
  late String lang;
  late String detectedLanguage;
  String capturedText = "";
  bool isTablet = getDeviceType() == 'tablet' ? true : false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static NotesBloc get(context) => BlocProvider.of(context);

  NotesBloc() : super(NotesInitial()) {
    on<NotesEvent>((event, emit) {});
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
    extDir = await ExternalPath.getExternalStorageDirectories();
  }

  createVoiceFolder() async {
    Directory voice = Directory("${appDir.path}/Voice");
    if ((await voice.exists())) {
      // print("Path exist");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await getStoragePermission();
      }
    } else {
      if (kDebugMode) {
        print("not exist");
      }
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        await voice.create();
      }
    }
  }

  getHomePage() async {
    final prefs = await SharedPreferences.getInstance();
    openPage = prefs.getString('Pages') ?? 'Home';
    openPage == 'Home'
        ? currentIndex = 0
        : openPage == 'Text'
            ? currentIndex = 1
            : currentIndex = 2;
  }

  getScreenWidth(context) {
    width = MediaQuery.of(context).size.width;
  }

  String getAppTheme(context) {
    var currentTheme = AdaptiveTheme.of(context).mode;
    late String theme;
    currentTheme == AdaptiveThemeMode.light
        ? theme = "Light"
        : currentTheme == AdaptiveThemeMode.dark
            ? theme = "Dark"
            : theme = "System";
    return theme;
  }

  Future getStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    PermissionStatus status1 = await Permission.accessMediaLocation.request();
    PermissionStatus status2 = await Permission.manageExternalStorage.request();
    if (kDebugMode) {
      print('status $status -> $status1 -> $status2');
    }
    if (status.isGranted && status2.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
      await openAppSettings();
    } else if (status.isDenied) {
      if (kDebugMode) {
        print('Permission Denied');
      }
    }
  }

  Future deleteFile(location) async {
    try {
      await File(location).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
//
//   Future<void> checkCamPerms() async {
//     var status = await Permission.camera.status;
//     if (status.isDenied) {
//       if (kDebugMode) {
//         print("denied");
//       }
//     }
//
// // You can can also directly ask the permission about its status.
//     if (await Permission.location.isRestricted) {
//       if (kDebugMode) {
//         print("restricted");
//       }
//     }
//   }
//
//   Future getImageGallery(String chLang) async {
//     final ImagePicker picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       chLang == 'en' ? captureText(pickedFile.path) : captureTextCloud(pickedFile.path);
//     } else {
//       if (kDebugMode) {
//         print('No image selected.');
//       }
//     }
//   }
//
//   Future getImageCamera(String chLang) async {
//     final ImagePicker picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       chLang == 'en' ? await captureText(pickedFile.path) : await captureTextCloud(pickedFile.path);
//     } else {
//       if (kDebugMode) {
//         print('No image selected.');
//       }
//     }
//   }
//
//   Future<void> captureTextCloud(String path) async {
//     // Create an MLTextAnalyzer object.
//     MLTextAnalyzer analyzer = MLTextAnalyzer();
//     // Create an MLTextAnalyzerSetting object to configure the recognition.
//     final setting = MLTextAnalyzerSetting.remote(path: path);
//     setting.language = 'ar';
//     // Call asyncAnalyzeFrame to recognize text asynchronously.
//     try {
//       MLText text = await analyzer.asyncAnalyseFrame(setting);
//       capturedText = text.stringValue.toString();
//     } on Exception catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     //bool result =
//     await analyzer.destroy();
//   }
//
//   Future<void> captureText(String path) async {
//     // Create an MLTextAnalyzer object.
//     MLTextAnalyzer analyzer = MLTextAnalyzer();
//     // Create an MLTextAnalyzerSetting object to configure the recognition.
//     final setting = MLTextAnalyzerSetting.local(path: path, language: "en");
//     // Call asyncAnalyzeFrame to recognize text asynchronously.
//     try {
//       MLText text = await analyzer.asyncAnalyseFrame(setting);
//       capturedText = text.stringValue.toString();
//     } on Exception catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//     }
//     //bool result =
//     await analyzer.destroy();
//   }

  Future<void> detectLanguage(String source) async {
    // Create an MLLangDetector object.
    MLLangDetector detector = MLLangDetector();

// Create MLLangDetectorSetting to configure detection.
    final setting = MLLangDetectorSetting.create(sourceText: source, isRemote: false);

// Get detection result with the highest confidence.
    final String? res = await detector.firstBestDetect(setting: setting);

    detectedLanguage = res!;

// Get multi-language detection results based on the supplied text.
//     List<MLDetectedLang> res = await detector.probabilityDetect(setting: setting);

// After the detection ends, stop the detector.
    await detector.stop();
  }

  showDeleteDialog(BuildContext context, List<Map> notes, int index) {
    return Dialogs.materialDialog(msg: "msg".tr(), title: "DeleteN".tr(), color: Theme.of(context).cardColor, context: context, actions: [
      IconsOutlineButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        text: 'Cancel'.tr(),
        iconData: Icons.cancel_outlined,
        textStyle: const TextStyle(color: Colors.grey),
        iconColor: Colors.grey,
      ),
      IconsButton(
        onPressed: () async {
          allNotesMap[index]["type"] == 1
              ? {
                  await deleteFile(allNotesMap[index]["content"]),
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
        color: colors[notes[index]['cindex']],
        textStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
    ]);
  }

  int calculateDifference(String stringDate) {
    var date = DateTime.parse(stringDate);
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
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
      return note['type'] == 0 ? title.contains(query.toLowerCase()) || content.contains(query.toLowerCase()) : title.contains(query.toLowerCase());
    }).toList();
    searchedALL = searched;
    onSearch();
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
    final prefs = await SharedPreferences.getInstance();
    await openDatabase('notes.db', version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, time Text, cindex INTEGER, tindex INTEGER, type INTEGER, edited Text, layout INTEGER, extra Text)');
    }, onOpen: (db) async {})
        .then((value) => database = value);
    viewIndex = prefs.getInt('viewIndex') ?? 0;
    viewIndexN = prefs.getInt('viewIndexN') ?? 0;
    viewIndexV = prefs.getInt('viewIndexV') ?? 0;
    adCounter = prefs.getInt('adCounter') ?? 0;
    showDate = prefs.getBool('showDate') ?? true;
    showShadow = prefs.getBool('showShadow') ?? false;
    showEdited = prefs.getBool('showEdit') ?? true;
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
      {required String title, required String content, required int index, required String time, required int layout, int? type = 0, int? tIndex = 0, String? edited = 'no'}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert('INSERT INTO Notes(title, content, cindex, tindex, type, time, edited ,layout, extra) VALUES("$title", "$content", "$index", "$tIndex", "$type","$time","$edited","$layout","")')
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
    await database.rawUpdate('UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, tindex = ?, type = ?, edited = ?, layout = ?, extra = ? WHERE id = ?',
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
        color: Theme.of(context).highlightColor.withOpacity(0.3),
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
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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

backUp() async {
  final dbFolder = await getDatabasesPath();
  File source1 = File('$dbFolder/notes.db');
  File source2 = File('${appDir.path}/Voice');
  File source3 = File('${appDir.path}/shared_prefs');
  Directory backup = Directory("${extDir[0]}/Notes/backup");
  if ((await backup.existsSync())) {
    // print("Path exist");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await getStoragePermission();
      await Permission.manageExternalStorage.request();
    }
  } else {
    if (kDebugMode) {
      print("not exist");
    }
    await backup.create(recursive: true);
  }
  String newPath = "${backup.path}/db/notes.db";
  await source1.copy(newPath);
  if (kDebugMode) {
    print("Successfully Copied DB");
  }
}
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}
