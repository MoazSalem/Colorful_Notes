import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/SideBar/info.dart';
import 'package:notes/Screens/SideBar/notes.dart';
import 'package:notes/Screens/SideBar/settings.dart';
import 'package:notes/Screens/SideBar/voice_notes.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:notes/Widgets/SideBar.dart';

late var interstitialAd;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdManagerInterstitialAd.load(
        adUnitId: 'ca-app-pub-1796999612396305/6912830112',
        request: const AdManagerAdRequest(),
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
          onAdLoaded: (AdManagerInterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: AdaptiveTheme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: AdaptiveTheme.of(context).brightness,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness: AdaptiveTheme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Theme.of(context).cardColor,
        ),
        child: BlocProvider(
          create: (context) => NotesBloc()..startPage(),
          child: BlocConsumer<NotesBloc, NotesState>(
            listener: (context, state) {},
            builder: (context, state) {
              var B = NotesBloc.get(context);
              B.lang = context.locale.toString();
              B.getScreenWidth(context);
              List<Widget> page = [
                Builder(
                  builder: (context) {
                    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), child: const HomePage());
                  },
                ),
                Builder(
                  builder: (context) {
                    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), child: const NotesPage());
                  },
                ),
                Builder(
                  builder: (context) {
                    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), child: const VoiceNotesPage());
                  },
                ),
                Builder(
                  builder: (context) {
                    return MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
                        child: SettingsPage(
                          currentTheme: B.getAppTheme(context),
                          black: B.isBlack ? "Amoled" : "Dark",
                          sB: B.sbIndex == 0
                              ? "Left"
                              : B.sbIndex == 1
                                  ? "Left Inv"
                                  : B.sbIndex == 2
                                      ? "Right"
                                      : "Right Inv",
                          fabLoc: B.fabIndex == 0 ? "Right" : "Left",
                        ));
                  },
                ),
                Builder(
                  builder: (context) {
                    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), child: const InfoPage());
                  },
                ),
              ];
              return Scaffold(
                resizeToAvoidBottomInset: false,
                key: B.scaffoldKey,
                body: B.loading
                    ? Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                          ),
                        ),
                      )
                    : Row(
                        children: B.sbIndex == 2 || B.sbIndex == 3
                            ? [
                                Expanded(
                                  flex: 5,
                                  child: page[B.currentIndex],
                                ),
                                Container(
                                  height: double.infinity,
                                  width: 1,
                                  color: Theme.of(context).highlightColor.withOpacity(0.15),
                                ),
                                sideBar(context, B.sbIndex == 3 ? true : false), // Divider
                              ]
                            : [
                                sideBar(context, B.sbIndex == 1 ? true : false),
                                Container(
                                  height: double.infinity,
                                  width: 1,
                                  color: Theme.of(context).highlightColor.withOpacity(0.15),
                                ), // Divider
                                Expanded(
                                  flex: 5,
                                  child: page[B.currentIndex],
                                ),
                              ],
                      ),
              );
            },
          ),
        ));
  }
}

final BannerAd banner1 = BannerAd(
  adUnitId: 'ca-app-pub-1796999612396305/5626834454',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
final BannerAd banner2 = BannerAd(
  adUnitId: 'ca-app-pub-1796999612396305/2782013418',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);
