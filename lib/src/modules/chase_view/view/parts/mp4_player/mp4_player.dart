import 'dart:async';

import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../../const/sizings.dart';
import '../../../../../device_info.dart';
import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../../shared/widgets/loaders/loading.dart';
import '../../providers/providers.dart';
import '../casting_options/google_cast/google_cast_controller.dart';
import '../casting_options/streaming_option.dart';
import 'custom_video_progress_indicator.dart';
import 'providers.dart';

void popVideoView(BuildContext context, [VoidCallback? onLandscalePop]) {
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    final bool isTabletOrMonitor =
        DeviceScreen.isTablet(context) || DeviceScreen.isMonitor(context);
    if (!isTabletOrMonitor) {
      if (onLandscalePop != null) {
        onLandscalePop();
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    } else {
      Navigator.of(context).pop();
    }
  } else {
    Navigator.of(context).pop();
  }
}

class Mp4VideoPlayerViewWrapper extends StatefulWidget {
  const Mp4VideoPlayerViewWrapper({
    super.key,
    required this.mp4Url,
  });

  final String mp4Url;

  @override
  State<Mp4VideoPlayerViewWrapper> createState() =>
      _Mp4VideoPlayerViewWrapperState();
}

class _Mp4VideoPlayerViewWrapperState extends State<Mp4VideoPlayerViewWrapper> {
  bool reloadPlayer = false;

  void reloadMp4Player() {
    setState(() {
      reloadPlayer = true;
    });
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        reloadPlayer = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant Mp4VideoPlayerViewWrapper oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.mp4Url != oldWidget.mp4Url) {
      reloadMp4Player();
    }
  }

  @override
  Widget build(BuildContext context) {
    return reloadPlayer
        ? const CircularAdaptiveProgressIndicatorWithBg()
        : _Mp4VideoPlayerView(
            mp4Url: widget.mp4Url,
          );
  }
}

class _Mp4VideoPlayerView extends ConsumerStatefulWidget {
  const _Mp4VideoPlayerView({
    super.key,
    required this.mp4Url,
  });

  final String mp4Url;

  @override
  ConsumerState<_Mp4VideoPlayerView> createState() =>
      _Mp4VideoPlayerViewState();
}

class _Mp4VideoPlayerViewState extends ConsumerState<_Mp4VideoPlayerView> {
  late VideoPlayerController _controller;
  late bool isPlayerInitialized;

  void listenForBufferUpdate() {
    _controller.addListener(() {
      ref.read(isPlayingAnyVideoProvider.state).update(
            (bool state) => _controller.value.isPlaying,
          );
    });
  }

  Future<void> changeYoutubeVideo(String url) async {
    initializePlayer(url);
  }

  void initializePlayer(String mp4Url) {
    _controller = VideoPlayerController.network(
      mp4Url,
    );

    _controller.initialize().then((value) {
      setState(() {
        isPlayerInitialized = true;
        _controller.play();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isPlayerInitialized = false;
    initializePlayer(widget.mp4Url);
    _controller.addListener(listenForBufferUpdate);
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
    ref.listen<bool?>(
      mp4PlauerPlayPauseStateProovider,
      (bool? prev, bool? next) {
        if (next != null && next != _controller.value.isPlaying) {
          if (next) {
            _controller.play();
          } else {
            _controller.pause();
          }
        }
      },
    );

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        VideoOverlayControlls(
          controller: _controller,
        ),
        if (!isPlayerInitialized)
          Positioned(
            left: kPaddingSmallConstant,
            top: kPaddingSmallConstant,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                popVideoView(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        if (!isPlayerInitialized)
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
    super.key,
    required VideoPlayerController controller,
  })  : _controller = controller;

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
    super.key,
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

  void listenForCastingSessionUpdates(CastSessionState castSessionState) {
    switch (castSessionState) {
      case CastSessionState.connected:
        _controller.setVolume(0);
        break;
      case CastSessionState.connecting:
        _controller.pause();
        break;
      case CastSessionState.closed:
        _controller.setVolume(1);
        break;
      default:
    }
  }

  void listenForVideoUrlChanges(String? url) {
    if (url == null) {
      _controller.setVolume(1);
      return;
    }
    final MediaPlayer currentMediaType = MediaPlayer.getMediaType(url);
    switch (currentMediaType) {
      case MediaPlayer.youtube:
        _controller.setVolume(1);

        break;
      case MediaPlayer.mp4:
        if (ref
            .read(googleCastVideoPlayControllerProvider.notifier)
            .isSessionStarted) {
          _controller.setVolume(0);
        } else {
          _controller.setVolume(1);
        }
        break;
      case MediaPlayer.m3u8:
        _controller.setVolume(0);

        break;
      default:
    }
  }

  void playPauseListener() {
    if (_controller.value.isPlaying != isPlaying) {
      setState(() {
        isPlaying = _controller.value.isPlaying;
        if (isPlaying) {
          ref
              .read(
                googleCastVideoPlayControllerProvider.notifier,
              )
              .playVideo();
        } else {
          ref
              .read(
                googleCastVideoPlayControllerProvider.notifier,
              )
              .pauseVideo();
        }
      });
      listenForVideoUrlChanges(ref.read(currentlyPlayingVideoUrlProvider));
    }
    ref.read(googleCastVideoPlayControllerProvider.notifier).duration =
        _controller.value.position;
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
    ref.listen<CastSessionState>(
      googleCastVideoPlayControllerProvider,
      (CastSessionState? prev, CastSessionState next) {
        listenForCastingSessionUpdates(next);
      },
    );

    // ignore: cascade_invocations
    ref.listen<String?>(
      currentlyPlayingVideoUrlProvider,
      (String? prev, String? next) {
        listenForVideoUrlChanges(next);
      },
    );

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
          right: 0,
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  popVideoView(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const StreamingOptionsList(),
              SizedBox(
                width:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 90
                        : kItemsSpacingMediumConstant,
              ),
            ],
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
                    ref
                        .read(
                          googleCastVideoPlayControllerProvider.notifier,
                        )
                        .seekVideo(duration: backToDuration.inSeconds);
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
                    ref
                        .read(
                          googleCastVideoPlayControllerProvider.notifier,
                        )
                        .seekVideo(duration: forwardToDuration.inSeconds);
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
                  onVideoTapped: (Duration duration) {
                    widget.onVideoTapped();
                    ref
                        .read(
                          googleCastVideoPlayControllerProvider.notifier,
                        )
                        .seekVideo(duration: duration.inSeconds);
                  },
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
    super.key,
    required VideoPlayerController controller,
    required this.onVideoTapped,
  })  : _controller = controller;

  final VideoPlayerController _controller;
  final Function(Duration duration) onVideoTapped;

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
