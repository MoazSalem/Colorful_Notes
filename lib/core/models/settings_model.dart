class SettingsModel {
  final int sbIndex;
  final int fabIndex;
  final int themeIndex;
  final int homeViewIndex;
  final int textViewIndex;
  final int voiceViewIndex;
  final bool showDate;
  final bool showShadow;
  final bool showEdited;
  final bool colorful;
  final bool darkColors;
  final bool firstLaunch;
  final String lang;

  const SettingsModel({
    this.sbIndex = 0,
    this.fabIndex = 0,
    this.themeIndex = 0,
    this.homeViewIndex = 0,
    this.textViewIndex = 0,
    this.voiceViewIndex = 0,
    this.showDate = true,
    this.showShadow = false,
    this.showEdited = true,
    this.colorful = true,
    this.darkColors = false,
    this.firstLaunch = true,
    this.lang = "en",
  });

  SettingsModel copyWith({
    int? sbIndex,
    int? fabIndex,
    int? themeIndex,
    int? homeViewIndex,
    int? textViewIndex,
    int? voiceViewIndex,
    bool? showDate,
    bool? showShadow,
    bool? showEdited,
    bool? colorful,
    bool? darkColors,
    bool? firstLaunch,
    String? lang,
  }) {
    return SettingsModel(
      sbIndex: sbIndex ?? this.sbIndex,
      fabIndex: fabIndex ?? this.fabIndex,
      themeIndex: themeIndex ?? this.themeIndex,
      homeViewIndex: homeViewIndex ?? this.homeViewIndex,
      textViewIndex: textViewIndex ?? this.textViewIndex,
      voiceViewIndex: voiceViewIndex ?? this.voiceViewIndex,
      showDate: showDate ?? this.showDate,
      showShadow: showShadow ?? this.showShadow,
      showEdited: showEdited ?? this.showEdited,
      colorful: colorful ?? this.colorful,
      darkColors: darkColors ?? this.darkColors,
      firstLaunch: firstLaunch ?? this.firstLaunch,
      lang: lang ?? this.lang,
    );
  }

  // Method to convert class to a Map for Hive
  Map<String, dynamic> toJson() {
    return {
      'sbIndex': sbIndex,
      'fabIndex': fabIndex,
      'themeIndex': themeIndex,
      'homeViewIndex': homeViewIndex,
      'textViewIndex': textViewIndex,
      'voiceViewIndex': voiceViewIndex,
      'showDate': showDate,
      'showShadow': showShadow,
      'showEdited': showEdited,
      'colorful': colorful,
      'darkColors': darkColors,
      'firstLaunch': firstLaunch,
      'lang': lang,
    };
  }

  // Factory constructor to create a class from a map from Hive
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      sbIndex: json['sbIndex'] ?? 0,
      fabIndex: json['fabIndex'] ?? 0,
      themeIndex: json['themeIndex'] ?? 0,
      homeViewIndex: json['homeViewIndex'] ?? 0,
      textViewIndex: json['textViewIndex'] ?? 0,
      voiceViewIndex: json['voiceViewIndex'] ?? 0,
      showDate: json['showDate'] ?? true,
      showShadow: json['showShadow'] ?? false,
      showEdited: json['showEdited'] ?? true,
      colorful: json['colorful'] ?? false,
      darkColors: json['darkColors'] ?? false,
      firstLaunch: json['firstLaunch'] ?? true,
      lang: json['lang'] ?? 'en',
    );
  }
}
