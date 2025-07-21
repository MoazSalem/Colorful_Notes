import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/providers/settings_notifier.dart';
import 'package:colorful_notes/features/settings/ui/widgets/theme_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:colorful_notes/core/shared_widgets/custom_appbar.dart';
import 'package:colorful_notes/core/shared_widgets/custom_divider.dart';
import 'package:colorful_notes/features/settings/ui/widgets/setting_switch_tile.dart';
import 'package:colorful_notes/features/settings/ui/widgets/settings_dropdown_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the SettingsService instance from the locator
    final settings = ref.watch(settingsNotifierProvider).value!;
    final settingsService = ref.watch(settingsNotifierProvider.notifier);
    // Define UI constants based on device type
    final double titleSize = 22;
    final double subtitleSize = 12;
    final double switchSize = 50;
    const List<String> sbItems = [
      "Top Left",
      "Bottom Left",
      "Top Right",
      "Bottom Right",
      "Bottom Bar",
    ];
    const List<String> fabItems = ["Right", "Left"];
    const List<String> themeModes = ["System", "Dark", "Light"];
    List<Color> colors = settings.darkColors
        ? AppConsts.darkerColors
        : AppConsts.lightColors;

    // Use ValueListenableBuilder to reactively build the UI
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomAppbar(title: "Settings".tr(), top: 65),

          // --- Language Setting ---
          SettingsDropdownTile<String>(
            title: "Language".tr(),
            subtitle: "sLanguage".tr(),
            value: settings.lang == 'en' ? "English" : "Arabic",
            items: const ["English", "Arabic"],
            onChanged: (newValue) {
              final newLang = newValue == 'English' ? 'en' : 'ar';
              context.setLocale(Locale(newLang));
              settingsService.updateSettings(settings.copyWith(lang: newLang));
            },
            titleSize: titleSize,
            subtitleSize: subtitleSize,
          ),

          CustomDivider(),

          // --- Side Bar Location ---
          SettingsDropdownTile<String>(
            title: "Side Bar".tr(),
            subtitle: "sSide Bar".tr(),
            value: sbItems[settings.sbIndex],
            items: sbItems,
            onChanged: (newValue) {
              final newIndex = sbItems.indexOf(newValue!);
              settingsService.updateSettings(
                settings.copyWith(sbIndex: newIndex),
              );
            },
            titleSize: titleSize,
            subtitleSize: subtitleSize,
          ),

          CustomDivider(),

          // --- Create Button Location ---
          SettingsDropdownTile<String>(
            title: "Create Button".tr(),
            subtitle: "sCreate Button".tr(),
            value: fabItems[settings.fabIndex],
            items: fabItems,
            onChanged: (newValue) {
              final newIndex = fabItems.indexOf(newValue!);
              settingsService.updateSettings(
                settings.copyWith(fabIndex: newIndex),
              );
            },
            titleSize: titleSize,
            subtitleSize: subtitleSize,
          ),

          CustomDivider(),

          // --- Theme Changing tile ---
          ThemePopupMenu(
            themeIndex: settings.themeIndex,
            onChanged: (newIndex) {
              settingsService.updateSettings(
                settings.copyWith(themeIndex: newIndex),
              );
            },
          ),

          CustomDivider(),

          // --- Theme Mode ---
          SettingsDropdownTile<String>(
            title: "Theme Mode".tr(),
            subtitle: "sTheme Mode".tr(),
            value: themeModes[settings.themeMode],
            items: themeModes,
            onChanged: (newValue) {
              final newIndex = themeModes.indexOf(newValue!);
              settingsService.updateSettings(
                settings.copyWith(themeMode: newIndex),
              );
            },
            titleSize: titleSize,
            subtitleSize: subtitleSize,
          ),

          CustomDivider(),

          // --- Colorful Notes ---
          SettingsSwitchTile(
            title: "Colorful".tr(),
            subtitle: "sColorful".tr(),
            value: settings.colorful,
            onChanged: (newValue) {
              settingsService.updateSettings(
                settings.copyWith(colorful: newValue),
              );
            },
            switchSize: switchSize,
            titleSize: titleSize,
            subtitleSize: subtitleSize,
            color: settings.colorful ? colors[0] : null,
          ),

          CustomDivider(),

          // --- Darker Colors ---
          SettingsSwitchTile(
            title: "Darker Colors".tr(),
            subtitle: "sDarker Colors".tr(),
            value: settings.darkColors,
            onChanged: (newValue) {
              settingsService.updateSettings(
                settings.copyWith(darkColors: newValue),
              );
            },
            switchSize: switchSize,
            titleSize: titleSize,
            subtitleSize: subtitleSize,
            color: settings.colorful ? colors[1] : null,
          ),

          CustomDivider(),

          // --- Show Date ---
          SettingsSwitchTile(
            title: "Show Date".tr(),
            subtitle: "sShow Date".tr(),
            value: settings.showDate,
            onChanged: (newValue) {
              settingsService.updateSettings(
                settings.copyWith(showDate: newValue),
              );
            },
            switchSize: switchSize,
            titleSize: titleSize,
            subtitleSize: subtitleSize,
            color: settings.colorful ? colors[2] : null,
          ),

          // Add other settings tiles here in the same pattern...
          CustomDivider(),

          // --- Show Edited ---
          SettingsSwitchTile(
            title: "Show Edited".tr(),
            subtitle: "sShow Edited".tr(),
            value: settings.showEdited,
            onChanged: (newValue) {
              settingsService.updateSettings(
                settings.copyWith(showEdited: newValue),
              );
            },
            switchSize: switchSize,
            titleSize: titleSize,
            subtitleSize: subtitleSize,
            color: settings.colorful ? colors[3] : null,
          ),

          CustomDivider(),

          // --- Show Shadow ---
          SettingsSwitchTile(
            title: "Show Shadow".tr(),
            subtitle: "sShow Shadow".tr(),
            value: settings.showShadow,
            onChanged: (newValue) {
              settingsService.updateSettings(
                settings.copyWith(showShadow: newValue),
              );
            },
            switchSize: switchSize,
            titleSize: titleSize,
            subtitleSize: subtitleSize,
            color: settings.colorful ? colors[4] : null,
          ),

          CustomDivider(),

          SizedBox(height: 20),

          // --- Backup and Restore ---
          // SizedBox(
          //   height: isTablet ? 120 : 80,
          //   child: Center(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         TextButton(
          //           onPressed: () => C.bDialog(context), // Assuming helper
          //           child: Text(
          //             "Backup".tr(),
          //             style: TextStyle(
          //               fontSize: 20,
          //               color: settings.colorful
          //                   ? C.colors[3]
          //                   : C.theme.primary,
          //             ),
          //           ),
          //         ),
          //         TextButton(
          //           onPressed: () => C.rDialog(context), // Assuming helper
          //           child: Text(
          //             "Restore".tr(),
          //             style: TextStyle(
          //               fontSize: 20,
          //               color: settings.colorful
          //                   ? C.colors[4]
          //                   : C.theme.secondary,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          //
          // CustomDivider(),
        ],
      ),
    );
  }
}
