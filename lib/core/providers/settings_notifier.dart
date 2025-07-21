import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class SettingsNotifier extends AsyncNotifier<SettingsModel> {
  static late final Box box;
  final String _settingsKey = 'appSettings';

  @override
  Future<SettingsModel> build() async {
    box = await Hive.openBox("settingsBox");

    final storedSettings = box.get(_settingsKey);

    if (storedSettings == null) {
      final defaultSettings = SettingsModel();
      await box.put(_settingsKey, defaultSettings.toJson());
      return defaultSettings;
    }

    return SettingsModel.fromJson(storedSettings.cast<String, dynamic>());
  }

  Future<void> updateSettings(SettingsModel newSettings) async {
    // Update Hive
    await box.put(_settingsKey, newSettings.toJson());
    // Update state
    state = AsyncValue.data(newSettings);
  }
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsModel>(
      SettingsNotifier.new,
    );
