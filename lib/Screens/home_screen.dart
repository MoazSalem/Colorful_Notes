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
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
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
              double sizeBox = B.isTablet ? 60 : 30;
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
                        ));
                  },
                ),
                Builder(
                  builder: (context) {
                    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), child: const InfoPage());
                  },
                ),
              ];

              Widget sideBar() {
                return Container(
                  width: B.isTablet ? 100 : 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 8,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 65,
                              ),
                              IconButton(
                                  constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                                  onPressed: () {
                                    B.onIndexChanged(0);
                                  },
                                  icon: B.currentIndex != 0
                                      ? Icon(
                                          Icons.home_outlined,
                                          color: B.colors[0],
                                          size: B.isTablet ? 32 : 22,
                                        )
                                      : Icon(
                                          Icons.home,
                                          color: B.colors[0],
                                          size: B.isTablet ? 40 : 30,
                                        )),
                              SizedBox(
                                height: sizeBox,
                              ),
                              IconButton(
                                  constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                                  onPressed: () {
                                    B.onIndexChanged(1);
                                  },
                                  icon: B.currentIndex != 1
                                      ? Icon(
                                          Icons.sticky_note_2_outlined,
                                          color: B.colors[1],
                                          size: B.isTablet ? 30 : 20,
                                        )
                                      : Icon(
                                          Icons.sticky_note_2,
                                          color: B.colors[1],
                                          size: B.isTablet ? 40 : 30,
                                        )),
                              SizedBox(
                                height: sizeBox,
                              ),
                              IconButton(
                                  constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                                  onPressed: () {
                                    B.onIndexChanged(2);
                                  },
                                  icon: B.currentIndex != 2
                                      ? Icon(
                                          Icons.keyboard_voice_outlined,
                                          color: B.colors[3],
                                          size: B.isTablet ? 34 : 24,
                                        )
                                      : Icon(
                                          Icons.keyboard_voice,
                                          color: B.colors[3],
                                          size: B.isTablet ? 42 : 32,
                                        )),
                              SizedBox(
                                height: sizeBox,
                              ),
                              IconButton(
                                  constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                                  onPressed: () {
                                    B.onIndexChanged(3);
                                  },
                                  icon: B.currentIndex != 3
                                      ? Icon(
                                          Icons.settings_outlined,
                                          color: B.colors[2],
                                          size: B.isTablet ? 30 : 20,
                                        )
                                      : Icon(
                                          Icons.settings,
                                          color: B.colors[2],
                                          size: B.isTablet ? 40 : 30,
                                        )),
                            ],
                          )),
                      Expanded(
                        child: IconButton(
                            constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                            onPressed: () {
                              B.onIndexChanged(4);
                            },
                            icon: B.currentIndex != 4
                                ? Icon(
                                    Icons.info_outline,
                                    color: B.colors[4],
                                    size: B.isTablet ? 30 : 20,
                                  )
                                : Icon(
                                    Icons.info,
                                    color: B.colors[4],
                                    size: B.isTablet ? 40 : 30,
                                  )),
                      )
                    ],
                  ),
                );
              }

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
                        children: [
                          sideBar(),
                          Container(
                            height: double.infinity,
                            width: 1,
                            color: Theme.of(context).highlightColor.withOpacity(0.15),
                          ), // Divider
                          Expanded(
                            flex: 5,
                            child: page[B.currentIndex],
                          )
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
  request: AdRequest(),
  listener: BannerAdListener(),
);
final BannerAd banner2 = BannerAd(
  adUnitId: 'ca-app-pub-1796999612396305/2782013418',
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(),
);
