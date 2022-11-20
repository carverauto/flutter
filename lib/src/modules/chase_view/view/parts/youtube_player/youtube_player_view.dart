import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../models/chase/chase.dart';
import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../../shared/widgets/loaders/loading.dart';
import '../../providers/providers.dart';
import '../video_animations_overlay.dart';
import '../video_top_actions.dart';

class YoutubePlayerView extends ConsumerStatefulWidget {
  const YoutubePlayerView({
    super.key,
    required this.url,
    required this.isLive,
    required this.chase,
  });

  final String url;
  final bool isLive;
  final Chase chase;

  @override
  ConsumerState<YoutubePlayerView> createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends ConsumerState<YoutubePlayerView> {
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

  Future<void> changeYoutubeVideo(String url) async {
    initializeVideoController();
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
  void initState() {
    super.initState();
    initializeVideoController();
  }

  @override
  void didUpdateWidget(covariant YoutubePlayerView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      changeYoutubeVideo(widget.url);
    }
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
