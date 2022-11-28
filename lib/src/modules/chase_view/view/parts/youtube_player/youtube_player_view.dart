import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../models/chase/chase.dart';
import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../../shared/widgets/loaders/loading.dart';
import '../../providers/providers.dart';
import '../mp4_player/providers.dart';
import '../video_animations_overlay.dart';
import '../video_top_actions.dart';

class YoutubePlayerViewWrapper extends ConsumerStatefulWidget {
  const YoutubePlayerViewWrapper({
    super.key,
    required this.url,
    required this.isLive,
    required this.chase,
  });

  final String url;
  final bool isLive;
  final Chase chase;

  @override
  ConsumerState<YoutubePlayerViewWrapper> createState() =>
      _YoutubePlayerViewWrapperState();
}

class _YoutubePlayerViewWrapperState
    extends ConsumerState<YoutubePlayerViewWrapper> {
  bool reloadVideoPlayer = false;

  Future<void> changeYoutubeVideo(String url) async {
    setState(() {
      reloadVideoPlayer = true;
    });
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        reloadVideoPlayer = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant YoutubePlayerViewWrapper oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      changeYoutubeVideo(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return reloadVideoPlayer
        ? const CircularAdaptiveProgressIndicatorWithBg()
        : _YoutubePlayerView(
            url: widget.url,
            isLive: widget.isLive,
            chase: widget.chase,
          );
  }
}

class _YoutubePlayerView extends ConsumerStatefulWidget {
  const _YoutubePlayerView({
    required this.url,
    required this.isLive,
    required this.chase,
  });

  final String url;
  final bool isLive;
  final Chase chase;

  @override
  ConsumerState<_YoutubePlayerView> createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends ConsumerState<_YoutubePlayerView> {
  late YoutubePlayerController _controller;

  GlobalKey playerKey = GlobalKey(debugLabel: 'Player');
  bool reloadVideoPlayer = false;

  void isPlayingStatus() {
    ref
        .read(isPlayingAnyVideoProvider.state)
        .update((bool state) => _controller.value.isPlaying);
  }

  void initializeVideoController([bool autoPlay = true]) {
    final String? videoId = parseYoutubeUrlForVideoId(widget.url);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        isLive: widget.isLive,
        autoPlay: autoPlay,
      ),
    );
    _controller.addListener(isPlayingStatus);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(isPlayingStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool?>(
      youtubePlauerPlayPauseEventsStreamProovider,
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

    return reloadVideoPlayer
        ? const CircularAdaptiveProgressIndicatorWithBg()
        : YoutubePlayer(
            controller: _controller,
            topActions: VideoTopActions(
              controller: _controller,
            ),
            overlayInBetween: VideoAnimationsOverlay(
              controller: _controller,
              chase: widget.chase,
            ),
          );
  }
}
