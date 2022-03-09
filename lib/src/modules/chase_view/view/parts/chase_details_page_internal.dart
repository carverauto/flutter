import 'dart:core';

import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_details.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  YoutubePlayerController initializeVideoController({String? youtubeUrl}) {
    late final String? url;
    if (youtubeUrl == null) {
      final network = widget.chase.networks?.firstWhereOrNull((network) {
        final String? url = network.url;

        if (url != null) {
          return url.contains("youtube.com");
        }
        return false;
      });
      url = network?.url;
    } else {
      url = youtubeUrl;
    }

    late String? videoId;
    if (url != null) {
      final uri = Uri.parse(url);

      videoId = uri.queryParameters["v"] as String;
    } else {
      videoId = "";
    }
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    setState(() {});

    return _controller;
  }

  void changeYoutubeVideo(String url) async {
    initializeVideoController(
      youtubeUrl: url,
    );
    ref.read(playVideoProvider.state).update((state) => false);
    await Future<void>.delayed(Duration(milliseconds: 300));
    ref.read(playVideoProvider.state).update((state) => true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideoController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarOffsetAnimation = widget.appBarOffsetAnimation;
    final bottomListAnimation = widget.bottomListAnimation;
    final chase = widget.chase;

    return WillPopScope(
      onWillPop: () async {
        if (ref.read(isShowingChatsWindowProvide)) {
          ref.read(isShowingChatsWindowProvide.state).update((state) => false);
          return false;
        }
        return true;
      },
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
        builder: (context, video) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedBuilder(
                  animation: appBarOffsetAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: appBarOffsetAnimation.value,
                      child: child,
                    );
                  },
                  child: AppBar(
                    centerTitle: true,
                    elevation: 1.0,
                    title: Text(chase.name ?? "NA"),
                    actions: [],
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: bottomListAnimation,
                    builder: (context, child) {
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
    );
  }
}
