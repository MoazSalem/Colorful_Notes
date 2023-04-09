import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:notes/Services/flex_colors/app_color.dart';
import 'package:notes/Services/flex_colors/theme_controller.dart';

ThemeData flexTheme(
    {required String mode,
    required ThemeController themeController,
    required bool isDynamic,
    required ColorScheme dScheme}) {
  late ThemeData theme;
  ThemeData flexLight = FlexThemeData.light(
    colors: AppColor.customSchemes[themeController.schemeIndex].light,
    keyColors: FlexKeyColors(
      useKeyColors: themeController.useKeyColors,
      useSecondary: themeController.useSecondary,
      useTertiary: themeController.useTertiary,
      keepPrimary: themeController.keepPrimary,
      keepSecondary: themeController.keepSecondary,
      keepTertiary: themeController.keepTertiary,
    ),
    appBarElevation: 1,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 24,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
  ThemeData flexDark = FlexThemeData.dark(
    colors: AppColor.customSchemes[themeController.schemeIndex].dark,
    keyColors: FlexKeyColors(
      useKeyColors: themeController.useKeyColors,
      useSecondary: themeController.useSecondary,
      useTertiary: themeController.useTertiary,
      keepPrimary: themeController.keepDarkPrimary,
      keepSecondary: themeController.keepDarkSecondary,
      keepTertiary: themeController.keepDarkTertiary,
    ),
    appBarElevation: 1,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 24,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
  ThemeData dynamicLight = FlexThemeData.light(
    colorScheme: dScheme,
    appBarElevation: 1,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 24,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );
  ThemeData dynamicDark = FlexThemeData.dark(
    colorScheme: dScheme,
    appBarElevation: 1,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 24,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  );

  isDynamic
      ? mode == "light"
          ? theme = dynamicLight
          : theme = dynamicDark
      : mode == "light"
          ? theme = flexLight
          : theme = flexDark;
  return theme;
}
