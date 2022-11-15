import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../const/sizings.dart';
import '../../../../../shared/widgets/loaders/loading.dart';
import 'custom_video_progress_indicator.dart';

class Mp4VideoPlayerView extends StatefulWidget {
  const Mp4VideoPlayerView({
    Key? key,
    required this.mp4Url,
  }) : super(key: key);

  final String mp4Url;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<Mp4VideoPlayerView> {
  late VideoPlayerController _controller;
  late bool isOverlayActive;
  late Timer overlayerActiveTimer;

  @override
  void initState() {
    super.initState();
    isOverlayActive = false;
    overlayerActiveTimer = Timer(Duration.zero, () {});

    _controller = VideoPlayerController.network(
      widget.mp4Url,
    );
    _controller.initialize().then((value) {
      setState(() {
        _controller.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        InkWell(
          onTap: () {
            overlayerActiveTimer.cancel();
            setState(() {
              isOverlayActive = true;
            });
            overlayerActiveTimer = Timer(const Duration(seconds: 3), () {
              setState(() {
                isOverlayActive = false;
              });
            });
          },
          child: const SizedBox.expand(),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: true
              ? Mp4VideoPlayerControlls(
                  controller: _controller,
                )
              : const SizedBox.shrink(),
        ),
        Positioned(
          left: kPaddingSmallConstant,
          top: kPaddingSmallConstant,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        if (!_controller.value.isInitialized || _controller.value.isBuffering)
          const IgnorePointer(
            child: Center(
              child: CircularAdaptiveProgressIndicatorWithBg(),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Mp4VideoPlayerControlls extends StatefulWidget {
  const Mp4VideoPlayerControlls({
    required this.controller,
    this.bufferIndicator,
  });

  final VideoPlayerController controller;

  final Widget? bufferIndicator;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<Mp4VideoPlayerControlls>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;

  late bool isPlaying;

  void playPauseListener() {
    if (_controller.value.isPlaying != isPlaying) {
      setState(() {
        isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    isPlaying = _controller.value.isPlaying;
    _controller.addListener(playPauseListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.removeListener(playPauseListener);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1.3,
              colors: [
                Colors.transparent,
                Colors.black,
              ],
            ),
          ),
        ),
        Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async {
                      final Duration currentPosition =
                          await widget.controller.position ?? Duration.zero;
                      final Duration backToDuration =
                          Duration(seconds: currentPosition.inSeconds - 10);
                      await widget.controller.seekTo(backToDuration);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.replay_10_outlined,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                Material(
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      isPlaying ? _controller.pause() : _controller.play();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: isPlaying
                          ? const Icon(
                              Icons.pause,
                              size: 36,
                            )
                          : const Icon(
                              Icons.play_arrow,
                              size: 36,
                            ),
                    ),
                  ),
                ),
                Material(
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async {
                      final Duration currentPosition =
                          await widget.controller.position ?? Duration.zero;
                      final Duration forwardToDuration =
                          Duration(seconds: currentPosition.inSeconds + 10);
                      await widget.controller.seekTo(forwardToDuration);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.forward_10,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingMediumConstant,
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      final Duration elapsedTime =
                          widget.controller.value.position;

                      return Text(
                        durationFormatter(elapsedTime.inMilliseconds),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPaddingSmallConstant,
                        vertical: kPaddingSmallConstant,
                      ),
                      child: SizedBox(
                        height: 15,
                        child: CustomVideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      final Duration totalDuration =
                          widget.controller.value.duration;

                      return Text(
                        durationFormatter(totalDuration.inMilliseconds),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String durationFormatter(int milliSeconds) {
  int seconds = milliSeconds ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final int minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final String hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final String minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final String secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final String formattedTime =
      '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';
  return formattedTime;
}
