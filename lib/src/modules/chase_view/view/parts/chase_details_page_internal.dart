import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../providers/providers.dart';
import 'chase_details.dart';
import 'chase_details_reactive_info.dart';

class ChaseDetailsInternal extends ConsumerStatefulWidget {
  const ChaseDetailsInternal({
    Key? key,
    required this.chase,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
    required this.logger,
    required this.chatsRow,
    required this.chatsView,
  }) : super(key: key);
  final Chase chase;
  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;
  final Logger logger;
  final Widget chatsRow;
  final Widget chatsView;

  @override
  ConsumerState<ChaseDetailsInternal> createState() =>
      _ChaseDetailsInternalState();
}

class _ChaseDetailsInternalState extends ConsumerState<ChaseDetailsInternal> {
  final bool expandChats = false;
  late YoutubePlayerController _controller;

  late final Animation<Offset> appBarOffsetAnimation;
  late final Animation<Offset> bottomListAnimation;
  late final Chase chase;
  GlobalKey playerKey = GlobalKey(debugLabel: 'Player');
  void initializeVideoController(String? videoId, [bool autoPlay = false]) {
    late final String? url;
    late final String? playerVideoId;
    if (videoId == null) {
      final ChaseNetwork? network =
          widget.chase.networks?.firstWhereOrNull((ChaseNetwork network) {
        final String? url = network.url;

        if (url != null) {
          return isValidYoutubeUrl(url);
        }

        return false;
      });
      url = network?.url;
      playerVideoId = url != null ? parseYoutubeUrlForVideoId(url) : null;
      Future<void>.microtask(() {
        ref
            .read(playingVideoIdProvider.state)
            .update((String? state) => playerVideoId);
      });
    } else {
      playerVideoId = videoId;
    }

    _controller = YoutubePlayerController(
      initialVideoId: playerVideoId ?? '',
      flags: YoutubePlayerFlags(
        isLive: widget.chase.live ?? false,
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
      videoId,
      true,
    );
    ref.read(playVideoProvider.state).update((bool state) => false);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    ref.read(playVideoProvider.state).update((bool state) => true);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController(null);
    appBarOffsetAnimation = widget.appBarOffsetAnimation;
    bottomListAnimation = widget.bottomListAnimation;
    chase = widget.chase;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChaseHeroSectionBuilder player = ChaseHeroSectionBuilder(
      key: playerKey,
      chase: chase,
      imageUrl: chase.imageURL,
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (ref.read(isShowingChatsWindowProvide)) {
            ref
                .read(isShowingChatsWindowProvide.state)
                .update((bool state) => false);
            return false;
          }
          return true;
        },
        child: ChaseAppYoutubeController(
          youtubePlayerController: _controller,
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return orientation == Orientation.landscape
                  ? Scaffold(body: player)
                  : Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomInset: false,
                      body: AnimatedBuilder(
                        animation: bottomListAnimation,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.translate(
                            offset: bottomListAnimation.value,
                            child: child,
                          );
                        },
                        child: Column(
                          children: [
                            player,
                            Expanded(
                              child: ChaseDetails(
                                chase: chase,
                                imageURL: chase.imageURL,
                                logger: widget.logger,
                                onYoutubeNetworkTap: changeYoutubeVideo,
                                chatsRow: widget.chatsRow,
                                chatsView: widget.chatsView,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class ChaseAppYoutubeController extends InheritedWidget {
  const ChaseAppYoutubeController({
    super.key,
    required this.youtubePlayerController,
    required super.child,
  });
  final YoutubePlayerController youtubePlayerController;
  static ChaseAppYoutubeController of(BuildContext context) {
    final ChaseAppYoutubeController? result =
        context.dependOnInheritedWidgetOfExactType<ChaseAppYoutubeController>();
    assert(result != null, 'No ChaseAppYoutubeController found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ChaseAppYoutubeController old) =>
      youtubePlayerController != old.youtubePlayerController;
}
