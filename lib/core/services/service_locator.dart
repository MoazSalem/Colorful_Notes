import 'package:colorful_notes/core/services/settings_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // open a named hive box to store settings
  Box box = await Hive.openBox("settingsBox");
  serviceLocator.registerLazySingleton(() => box);
  serviceLocator.registerLazySingleton(() => SettingsService());
}
