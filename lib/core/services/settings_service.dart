import 'package:flutter/foundation.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'service_locator.dart';

const String _settingsKey = 'appSettings';

class SettingsService {
  final Box _settingsBox = serviceLocator<Box>();

  // A ValueNotifier to hold and notify about the state of our settings
  // We initialize it with default settings
  late final ValueNotifier<SettingsModel> settings;

  SettingsService() {
    _init();
  }

  void _init() {
    // Try to get the saved settings from Hive
    final storedSettings = _settingsBox.get(_settingsKey);
    if (storedSettings != null) {
      // If found, load them from the map
      settings = ValueNotifier(
        SettingsModel.fromJson(storedSettings.cast<String, dynamic>()),
      );
    } else {
      // Otherwise, use the default model
      settings = ValueNotifier(const SettingsModel());
    }
  }

  Future<void> updateSettings(SettingsModel newSettings) async {
    // Update the ValueNotifier to trigger UI rebuilds
    settings.value = newSettings;
    // Save the new settings model to Hive
    await _settingsBox.put(_settingsKey, newSettings.toJson());
  }
}
