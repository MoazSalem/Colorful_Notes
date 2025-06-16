import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // open a named hive box to store settings
  Box box = await Hive.openBox("settingsBox");
  getIt.registerLazySingleton(() => box);
}
