import 'package:flutter/material.dart';

class SettingsModel {
  final int sbIndex;
  final int fabIndex;
  final bool showDate;
  final bool showShadow;
  final bool showEdited;
  final bool colorful;
  final bool darkColors;
  final bool harmonizeColor;
  final String lang;
  final String openPage;
  final ThemeMode currentTheme;

  const SettingsModel({
    this.sbIndex = 0,
    this.fabIndex = 0,
    this.showDate = true,
    this.showShadow = false,
    this.showEdited = true,
    this.colorful = false,
    this.darkColors = false,
    this.harmonizeColor = true,
    this.lang = "en",
    this.openPage = "Home",
    this.currentTheme = ThemeMode.system,
  });

  SettingsModel copyWith({
    int? sbIndex,
    int? fabIndex,
    bool? showDate,
    bool? showShadow,
    bool? showEdited,
    bool? colorful,
    bool? darkColors,
    bool? harmonizeColor,
    String? lang,
    String? openPage,
    ThemeMode? currentTheme,
  }) {
    return SettingsModel(
      sbIndex: sbIndex ?? this.sbIndex,
      fabIndex: fabIndex ?? this.fabIndex,
      showDate: showDate ?? this.showDate,
      showShadow: showShadow ?? this.showShadow,
      showEdited: showEdited ?? this.showEdited,
      colorful: colorful ?? this.colorful,
      darkColors: darkColors ?? this.darkColors,
      harmonizeColor: harmonizeColor ?? this.harmonizeColor,
      lang: lang ?? this.lang,
      openPage: openPage ?? this.openPage,
      currentTheme: currentTheme ?? this.currentTheme,
    );
  }

  // Method to convert class to a Map for Hive
  Map<String, dynamic> toJson() {
    return {
      'sbIndex': sbIndex,
      'fabIndex': fabIndex,
      'showDate': showDate,
      'showShadow': showShadow,
      'showEdited': showEdited,
      'colorful': colorful,
      'darkColors': darkColors,
      'harmonizeColor': harmonizeColor,
      'lang': lang,
      'openPage': openPage,
      // Store ThemeMode as a string name
      'currentTheme': currentTheme.name,
    };
  }

  // Factory constructor to create a class from a map from Hive
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      sbIndex: json['sbIndex'] ?? 0,
      fabIndex: json['fabIndex'] ?? 0,
      showDate: json['showDate'] ?? true,
      showShadow: json['showShadow'] ?? false,
      showEdited: json['showEdited'] ?? true,
      colorful: json['colorful'] ?? false,
      darkColors: json['darkColors'] ?? false,
      harmonizeColor: json['harmonizeColor'] ?? true,
      lang: json['lang'] ?? 'en',
      openPage: json['openPage'] ?? 'Home',
      // Convert string name back to ThemeMode enum
      currentTheme: ThemeMode.values.firstWhere(
        (e) => e.name == json['currentTheme'],
        orElse: () => ThemeMode.system,
      ),
    );
  }
}
