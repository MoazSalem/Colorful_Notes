import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPlayer extends StatefulWidget {
  final List<Map> voiceMap;
  final int index;
  final List<Color> colors;
  final int viewMode;
  final bool isTablet;

  const SoundPlayer(
      {Key? key,
      required this.voiceMap,
      required this.index,
      required this.colors,
      required this.viewMode,
      required this.isTablet})
      : super(key: key);

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackSpeed = 1.0;
  bool play = false;
  PlayerState currentState = PlayerState.stopped;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPositionChanged.listen((Duration p) => setState(() => position = p));
    audioPlayer.onDurationChanged.listen((Duration p) => setState(() => duration = p));
    audioPlayer.onPlayerStateChanged.listen(
      (PlayerState s) => currentState = s,
    );
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        audioPlayer.setSourceDeviceFile(widget.voiceMap[widget.index]["content"]);
        position = Duration.zero;
        play = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    audioPlayer.setSourceDeviceFile(widget.voiceMap[widget.index]["content"]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return widget.viewMode == 0
        ? StatefulBuilder(
            builder: (context, setState) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      FittedBox(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: width * 0.050926),
                          child: SizedBox(
                              width: width * 0.50926,
                              height: width * 0.050926,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: width * 0.025463,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: width * 0.01567,
                                      elevation: 0,
                                      pressedElevation: 0),
                                  overlayShape:
                                      RoundSliderOverlayShape(overlayRadius: width * 0.03565),
                                ),
                                child: Slider(
                                  activeColor: widget.voiceMap[widget.index]['tindex'] == 0
                                      ? Colors.white
                                      : Colors.black,
                                  thumbColor: widget.voiceMap[widget.index]['tindex'] == 0
                                      ? Colors.white
                                      : Colors.black,
                                  inactiveColor: widget.voiceMap[widget.index]['tindex'] == 0
                                      ? Colors.white54
                                      : Colors.black54,
                                  value: position.inSeconds.toDouble(),
                                  min: 0,
                                  max: duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    setState(() async {
                                      final position = Duration(seconds: value.toInt());
                                      await audioPlayer.seek(position);
                                      play = true;
                                    });
                                  },
                                ),
                              )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.030556),
                            child: IconButton(
                                constraints: BoxConstraints.tightForFinite(
                                    height: width * 0.229167, width: width * 0.229167),
                                onPressed: () async {
                                  play = !play;
                                  play
                                      ? {
                                          await audioPlayer.resume(),
                                        }
                                      : await audioPlayer.pause();

                                  setState(() {});
                                },
                                icon: play
                                    ? Icon(
                                        Icons.pause_circle,
                                        size: width * 0.19097,
                                        color: widget.voiceMap[widget.index]['tindex'] == 0
                                            ? Colors.white
                                            : Colors.black,
                                      )
                                    : Icon(
                                        Icons.play_circle,
                                        size: width * 0.19097,
                                        color: widget.voiceMap[widget.index]['tindex'] == 0
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: width * 0.02037),
                            child: Column(
                              children: [
                                FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(width * 0.02037),
                                    child: Text(
                                      play
                                          ? parseTime(position)
                                          : currentState != PlayerState.paused
                                              ? parseTime(duration)
                                              : parseTime(position),
                                      style: TextStyle(
                                          color: widget.voiceMap[widget.index]['tindex'] == 0
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    currentState == PlayerState.playing
                                        ? {
                                            playbackSpeed < 2.0
                                                ? playbackSpeed += 0.5
                                                : playbackSpeed = 1.0,
                                            await audioPlayer.setPlaybackRate(playbackSpeed),
                                          }
                                        : null;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: width * 0.07639,
                                    width: width * 0.10185,
                                    decoration: BoxDecoration(
                                        color: widget.voiceMap[widget.index]['tindex'] == 0
                                            ? Colors.white
                                            : Colors.black,
                                        borderRadius: BorderRadius.circular(width * 0.050926)),
                                    child: Center(
                                      child: Text(
                                        "${playbackSpeed % 1 == 0 ? playbackSpeed.toInt() : playbackSpeed.toStringAsFixed(1)}x",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: widget
                                                .colors[widget.voiceMap[widget.index]['cindex']]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : widget.viewMode == 1
            ? Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  height: width * 0.155324,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    constraints: BoxConstraints.tightForFinite(
                                        height: width * 0.15278, width: width * 0.1324),
                                    onPressed: () async {
                                      play = !play;
                                      play
                                          ? {
                                              await audioPlayer.resume(),
                                            }
                                          : await audioPlayer.pause();

                                      setState(() {});
                                    },
                                    icon: play
                                        ? Icon(
                                            Icons.pause_circle,
                                            size: width * 0.10185,
                                            color: widget.voiceMap[widget.index]['tindex'] == 0
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        : Icon(
                                            Icons.play_circle,
                                            size: width * 0.10185,
                                            color: widget.voiceMap[widget.index]['tindex'] == 0
                                                ? Colors.white
                                                : Colors.black,
                                          )),
                                Padding(
                                  padding: EdgeInsets.only(bottom: width * 0.030555),
                                  child: SizedBox(
                                      width: widget.isTablet ? width * 0.47468 : width * 0.39468,
                                      height: width * 0.101852,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 10,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: width * 0.015878,
                                              elevation: 0,
                                              pressedElevation: 0),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: widget.isTablet
                                                  ? width * 0.030649
                                                  : width * 0.035649),
                                        ),
                                        child: Slider(
                                          activeColor: widget.voiceMap[widget.index]['tindex'] == 0
                                              ? Colors.white
                                              : Colors.black,
                                          thumbColor: widget.voiceMap[widget.index]['tindex'] == 0
                                              ? Colors.white
                                              : Colors.black,
                                          inactiveColor:
                                              widget.voiceMap[widget.index]['tindex'] == 0
                                                  ? Colors.white54
                                                  : Colors.black54,
                                          value: position.inSeconds.toDouble(),
                                          min: 0,
                                          max: duration.inSeconds.toDouble(),
                                          onChanged: (value) async {
                                            final position = Duration(seconds: value.toInt());
                                            await audioPlayer.seek(position);
                                          },
                                        ),
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    currentState == PlayerState.playing
                                        ? {
                                            playbackSpeed < 2.0
                                                ? playbackSpeed += 0.5
                                                : playbackSpeed = 1.0,
                                            await audioPlayer.setPlaybackRate(playbackSpeed),
                                          }
                                        : null;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: width * 0.07639,
                                    width: width * 0.10185,
                                    decoration: BoxDecoration(
                                        color: widget.voiceMap[widget.index]['tindex'] == 0
                                            ? Colors.white
                                            : Colors.black,
                                        borderRadius: BorderRadius.circular(width * 0.050926)),
                                    child: Center(
                                      child: Text(
                                        "${playbackSpeed % 1 == 0 ? playbackSpeed.toInt() : playbackSpeed.toStringAsFixed(1)}x",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: widget
                                                .colors[widget.voiceMap[widget.index]['cindex']]),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: widget.isTablet ? width * 0.3037 : width * 0.2037,
                                  bottom: width * 0.015278),
                              child: Text(
                                play
                                    ? parseTime(position)
                                    : currentState != PlayerState.paused
                                        ? parseTime(duration)
                                        : parseTime(position),
                                style: TextStyle(
                                    color: widget.voiceMap[widget.index]['tindex'] == 0
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
            : StatefulBuilder(
                builder: (context, setState) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FittedBox(
                            child: SizedBox(
                                width: width * 0.50926,
                                height: width * 0.050926,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 10,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: width * 0.015278,
                                        elevation: 0,
                                        pressedElevation: 0),
                                    overlayShape:
                                        RoundSliderOverlayShape(overlayRadius: width * 0.035649),
                                  ),
                                  child: Slider(
                                    activeColor: widget.voiceMap[widget.index]['tindex'] == 0
                                        ? Colors.white
                                        : Colors.black,
                                    thumbColor: widget.voiceMap[widget.index]['tindex'] == 0
                                        ? Colors.white
                                        : Colors.black,
                                    inactiveColor: widget.voiceMap[widget.index]['tindex'] == 0
                                        ? Colors.white54
                                        : Colors.black54,
                                    value: position.inSeconds.toDouble(),
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    onChanged: (value) async {
                                      final position = Duration(seconds: value.toInt());
                                      await audioPlayer.seek(position);
                                    },
                                  ),
                                )),
                          ),
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.03056),
                                  child: IconButton(
                                      constraints: BoxConstraints.tightForFinite(
                                          height: width * 0.229166, width: width * 0.229166),
                                      onPressed: () async {
                                        play = !play;
                                        play
                                            ? {
                                                await audioPlayer.resume(),
                                              }
                                            : await audioPlayer.pause();

                                        setState(() {});
                                      },
                                      icon: play
                                          ? Icon(
                                              Icons.pause_circle,
                                              size: width * 0.190972,
                                              color: widget.voiceMap[widget.index]['tindex'] == 0
                                                  ? Colors.white
                                                  : Colors.black,
                                            )
                                          : Icon(
                                              Icons.play_circle,
                                              size: width * 0.190972,
                                              color: widget.voiceMap[widget.index]['tindex'] == 0
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: width * 0.02037),
                                  child: Column(
                                    children: [
                                      FittedBox(
                                        child: Padding(
                                          padding: EdgeInsets.all(width * 0.02037),
                                          child: Text(
                                            play
                                                ? parseTime(position)
                                                : currentState != PlayerState.paused
                                                    ? parseTime(duration)
                                                    : parseTime(position),
                                            style: TextStyle(
                                                color: widget.voiceMap[widget.index]['tindex'] == 0
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          currentState == PlayerState.playing
                                              ? {
                                                  playbackSpeed < 2.0
                                                      ? playbackSpeed += 0.5
                                                      : playbackSpeed = 1.0,
                                                  await audioPlayer.setPlaybackRate(playbackSpeed),
                                                }
                                              : null;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: width * 0.07639,
                                          width: width * 0.10185,
                                          decoration: BoxDecoration(
                                              color: widget.voiceMap[widget.index]['tindex'] == 0
                                                  ? Colors.white
                                                  : Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(width * 0.050926)),
                                          child: Center(
                                            child: Text(
                                              "${playbackSpeed % 1 == 0 ? playbackSpeed.toInt() : playbackSpeed.toStringAsFixed(1)}x",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: widget.colors[widget.voiceMap[widget.index]
                                                      ['cindex']]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}

String parseTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}
