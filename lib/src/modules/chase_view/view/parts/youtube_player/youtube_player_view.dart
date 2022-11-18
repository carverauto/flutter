import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../models/chase/chase.dart';
import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
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
  void initializeVideoController([bool autoPlay = false]) {
    // late final String? url;
    // late final String? playerVideoId;
    // if (videoId == null) {
    //   final ChaseNetwork? network =
    //       widget.chase.networks?.firstWhereOrNull((ChaseNetwork network) {
    //     final String? url = network.url;

    //     if (url != null) {
    //       return isValidYoutubeUrl(url);
    //     }

    //     return false;
    //   });
    //   url = network?.url;
    //   playerVideoId = url != null ? parseYoutubeUrlForVideoId(url) : null;
    //   Future<void>.microtask(() {
    //     ref
    //         .read(playingVideoIdProvider.state)
    //         .update((String? state) => playerVideoId);
    //   });
    // } else {
    //   playerVideoId = videoId;
    // }
    final String? videoId = parseYoutubeUrlForVideoId(widget.url);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        isLive: widget.isLive,
        autoPlay: autoPlay,
      ),
    );
    // _controller.reload();

    setState(() {});
  }

  Future<void> changeYoutubeVideo(String url) async {
    final String? videoId = parseYoutubeUrlForVideoId(url);
    await Future<void>.microtask(() {
      ref.read(playingVideoIdProvider.state).update((String? state) => videoId);
    });

    initializeVideoController(
      true,
    );
    ref.read(playVideoProvider.state).update((bool state) => false);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    ref.read(playVideoProvider.state).update((bool state) => true);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController(true);
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      topActions: const VideoTopActions(),
      overlayInBetween: VideoAnimationsOverlay(
        controller: _controller,
        chase: widget.chase,
      ),
    );
  }
}
