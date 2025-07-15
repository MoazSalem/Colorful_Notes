import 'package:audioplayers/audioplayers.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:flutter/material.dart';

class SoundPlayer extends StatefulWidget {
  final Note voiceNote;
  final Color color;
  final Color? iconColor;
  final int viewMode;

  const SoundPlayer({
    super.key,
    required this.voiceNote,
    required this.color,
    required this.viewMode,
    this.iconColor,
  });

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackSpeed = 1.0;
  bool play = false;
  PlayerState currentState = PlayerState.stopped;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPositionChanged.listen(
      (Duration p) => setState(() => position = p),
    );
    audioPlayer.onDurationChanged.listen(
      (Duration p) => setState(() => duration = p),
    );
    audioPlayer.onPlayerStateChanged.listen(
      (PlayerState s) => currentState = s,
    );
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        audioPlayer.setSourceDeviceFile(widget.voiceNote.content);
        position = Duration.zero;
        play = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    audioPlayer.setSourceDeviceFile(widget.voiceNote.content);
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.iconColor ??
        (widget.voiceNote.tIndex == 0 ? Colors.white : Colors.black);
    final semiTransparentColor = color.withAlpha(100);
    return widget.viewMode == 0
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 240,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 12,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 9,
                          elevation: 0,
                          pressedElevation: 0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                      ),
                      child: Slider(
                        activeColor: color,
                        thumbColor: color,
                        inactiveColor: semiTransparentColor,
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
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          play = !play;
                          play
                              ? {await audioPlayer.resume()}
                              : await audioPlayer.pause();

                          setState(() {});
                        },
                        icon: play
                            ? Icon(Icons.pause_circle, size: 90, color: color)
                            : Icon(Icons.play_circle, size: 90, color: color),
                      ),
                      Column(
                        spacing: 10,
                        children: [
                          FittedBox(
                            child: Text(
                              play
                                  ? parseTime(position)
                                  : currentState != PlayerState.paused
                                  ? parseTime(duration)
                                  : parseTime(position),
                              style: TextStyle(color: color),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              currentState == PlayerState.playing
                                  ? {
                                      playbackSpeed < 2.0
                                          ? playbackSpeed += 0.5
                                          : playbackSpeed = 1.0,
                                      await audioPlayer.setPlaybackRate(
                                        playbackSpeed,
                                      ),
                                    }
                                  : null;
                              setState(() {});
                            },
                            child: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${playbackSpeed % 1 == 0 ? playbackSpeed.toInt() : playbackSpeed.toStringAsFixed(1)}x",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: widget.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : widget.viewMode == 1
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            play = !play;
                            play
                                ? {await audioPlayer.resume()}
                                : await audioPlayer.pause();

                            setState(() {});
                          },
                          icon: play
                              ? Icon(Icons.pause_circle, size: 50, color: color)
                              : Icon(Icons.play_circle, size: 50, color: color),
                        ),
                        SizedBox(
                          width: 175,
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 12,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                                elevation: 0,
                                pressedElevation: 0,
                              ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 10,
                              ),
                            ),
                            child: Slider(
                              activeColor: color,
                              thumbColor: color,
                              inactiveColor: semiTransparentColor,
                              value: position.inSeconds.toDouble(),
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final position = Duration(
                                  seconds: value.toInt(),
                                );
                                await audioPlayer.seek(position);
                              },
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
                                    await audioPlayer.setPlaybackRate(
                                      playbackSpeed,
                                    ),
                                  }
                                : null;
                            setState(() {});
                          },
                          child: Container(
                            width: 34,
                            height: 26,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "x${playbackSpeed % 1 == 0 ? playbackSpeed.toInt() : playbackSpeed.toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: widget.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      child: Text(
                        play
                            ? parseTime(position)
                            : currentState != PlayerState.paused
                            ? parseTime(duration)
                            : parseTime(position),
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        : Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FittedBox(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 14,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                          elevation: 0,
                          pressedElevation: 0,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 15,
                        ),
                      ),
                      child: Slider(
                        activeColor: color,
                        thumbColor: color,
                        inactiveColor: semiTransparentColor,
                        value: position.inSeconds.toDouble(),
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);
                        },
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            play = !play;
                            play
                                ? {await audioPlayer.resume()}
                                : await audioPlayer.pause();

                            setState(() {});
                          },
                          icon: play
                              ? Icon(size: 60, Icons.pause_circle, color: color)
                              : Icon(size: 60, Icons.play_circle, color: color),
                        ),
                        Column(
                          spacing: 5,
                          children: [
                            FittedBox(
                              child: Text(
                                play
                                    ? parseTime(position)
                                    : currentState != PlayerState.paused
                                    ? parseTime(duration)
                                    : parseTime(position),
                                style: TextStyle(color: color),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                currentState == PlayerState.playing
                                    ? {
                                        playbackSpeed < 2.0
                                            ? playbackSpeed += 0.5
                                            : playbackSpeed = 1.0,
                                        await audioPlayer.setPlaybackRate(
                                          playbackSpeed,
                                        ),
                                      }
                                    : null;
                                setState(() {});
                              },
                              child: Container(
                                height: 20,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "x${playbackSpeed % 1 == 0 ? playbackSpeed.toInt() : playbackSpeed.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: widget.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

String parseTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}
