import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../providers/providers.dart';
import 'chase_details.dart';
import 'video_animations_overlay.dart';
import 'video_top_actions.dart';

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
  void initializeVideoController(String? videoId) {
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
      ),
    );
    setState(() {});
  }

  Future<void> changeYoutubeVideo(String url) async {
    final String? videoId = parseYoutubeUrlForVideoId(url);
    await Future<void>.microtask(() {
      ref.read(playingVideoIdProvider.state).update((String? state) => videoId);
    });

    initializeVideoController(
      videoId,
    );
    ref.read(playVideoProvider.state).update((bool state) => false);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    ref.read(playVideoProvider.state).update((bool state) => true);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController(null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> appBarOffsetAnimation =
        widget.appBarOffsetAnimation;
    final Animation<Offset> bottomListAnimation = widget.bottomListAnimation;
    final Chase chase = widget.chase;
    final bool isTyping = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      top: isTyping,
      bottom: false,
      left: false,
      right: false,
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
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            topActions: const VideoTopActions(),
            overlayInBetween: VideoAnimationsOverlay(
              controller: _controller,
              chase: chase,
            ),
          ),
          builder: (BuildContext context, Widget video) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      // hide the appbar when typing
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -1),
                          end: const Offset(0, 0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: isTyping
                        ? const SizedBox.shrink()
                        : AnimatedBuilder(
                            animation: appBarOffsetAnimation,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.translate(
                                offset: appBarOffsetAnimation.value,
                                child: child,
                              );
                            },
                            child: AppBar(
                              centerTitle: true,
                              elevation: 1,
                              title: Text(chase.name ?? 'NA'),
                              actions: const [],
                            ),
                          ),
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: bottomListAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.translate(
                          offset: bottomListAnimation.value,
                          child: child,
                        );
                      },
                      child: ChaseDetails(
                        chase: chase,
                        imageURL: chase.imageURL,
                        logger: widget.logger,
                        youtubeVideo: video,
                        onYoutubeNetworkTap: changeYoutubeVideo,
                        chatsRow: widget.chatsRow,
                        chatsView: widget.chatsView,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
