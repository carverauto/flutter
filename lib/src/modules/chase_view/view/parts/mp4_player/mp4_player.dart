import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late bool isBuffering;

  void listenForBufferUpdate() {
    _controller.addListener(() {
      if (_controller.value.isBuffering != isBuffering) {
        log('BUffer Status Changed');
        setState(() {
          isBuffering = _controller.value.isBuffering;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isBuffering = true;
    _controller = VideoPlayerController.network(
      widget.mp4Url,
    );
    _controller.addListener(listenForBufferUpdate);
    _controller.initialize().then((value) {
      setState(() {
        _controller.play();
      });
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(listenForBufferUpdate)
      ..dispose();
    super.dispose();
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
        if (!isBuffering)
          VideoOverlayControlls(
            controller: _controller,
          ),
        if (!_controller.value.isInitialized || isBuffering)
          Positioned(
            left: kPaddingSmallConstant,
            top: kPaddingSmallConstant,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.landscape) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        if (!_controller.value.isInitialized || isBuffering)
          const IgnorePointer(
            child: Center(
              child: CircularAdaptiveProgressIndicatorWithBg(),
            ),
          ),
      ],
    );
  }
}

class VideoOverlayControlls extends StatefulWidget {
  const VideoOverlayControlls({
    Key? key,
    required VideoPlayerController controller,
  })  : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;

  @override
  State<VideoOverlayControlls> createState() => _VideoOverlayControllsState();
}

class _VideoOverlayControllsState extends State<VideoOverlayControlls> {
  late bool isOverlayActive;
  late Timer overlayerActiveTimer;

  void onVideoTapped() {
    overlayerActiveTimer.cancel();

    if (!isOverlayActive) {
      setState(() {
        isOverlayActive = true;
      });
    }

    overlayerActiveTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        isOverlayActive = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isOverlayActive = false;

    overlayerActiveTimer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    overlayerActiveTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              overlayerActiveTimer.cancel();

              setState(() {
                isOverlayActive = !isOverlayActive;
              });
            },
            child: const SizedBox.expand(),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isOverlayActive
                ? Mp4VideoPlayerControlls(
                    controller: widget._controller,
                    onVideoTapped: onVideoTapped,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class Mp4VideoPlayerControlls extends ConsumerStatefulWidget {
  const Mp4VideoPlayerControlls({
    required this.controller,
    this.bufferIndicator,
    required this.onVideoTapped,
  });

  final VideoPlayerController controller;

  final Widget? bufferIndicator;

  final VoidCallback onVideoTapped;

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends ConsumerState<Mp4VideoPlayerControlls>
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
        const IgnorePointer(
          child: DecoratedBox(
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
        ),
        Positioned(
          left: kPaddingSmallConstant,
          top: kPaddingSmallConstant,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            onPressed: () {
              if (MediaQuery.of(context).orientation == Orientation.landscape) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                shape: const CircleBorder(),
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    widget.onVideoTapped();
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
                    widget.onVideoTapped();
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
                    widget.onVideoTapped();
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
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            children: [
              Expanded(
                child: VideoDurationProgrssBar(
                  controller: _controller,
                  onVideoTapped: widget.onVideoTapped,
                ),
              ),
              IconButton(
                onPressed: () {
                  // get current orientation
                  final Orientation currentOrientation =
                      MediaQuery.of(context).orientation;

                  // set new orientation
                  if (currentOrientation == Orientation.portrait) {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  } else {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  }
                },
                icon: const Icon(
                  Icons.fullscreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoDurationProgrssBar extends StatelessWidget {
  const VideoDurationProgrssBar({
    Key? key,
    required VideoPlayerController controller,
    required this.onVideoTapped,
  })  : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;
  final VoidCallback onVideoTapped;

  @override
  Widget build(BuildContext context) {
    final Duration totalDuration = _controller.value.duration;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMediumConstant,
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              final Duration elapsedTime = _controller.value.position;

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
              ),
              child: SizedBox(
                height: 30,
                child: CustomVideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(
                    vertical: kPaddingSmallConstant,
                  ),
                  onScrubbed: onVideoTapped,
                ),
              ),
            ),
          ),
          Text(
            durationFormatter(totalDuration.inMilliseconds),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
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
