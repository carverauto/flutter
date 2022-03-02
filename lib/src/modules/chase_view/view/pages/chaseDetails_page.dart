import 'dart:core';

import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_details.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:chaseapp/pages/chat_page.dart';

class ChaseDetailsView extends ConsumerWidget {
  // ChaseDetailsView(this.observer);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final String chaseId;

  ChaseDetailsView({
    Key? key,
    required this.chaseId,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
  }) : super(key: key);

  final Logger logger = Logger("ChaseView");

  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;

  final bool expandChats = false;

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playVideoProvider);

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          _controller.addListener(() {});
        },
      ),
      builder: (context, video) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: ProviderStateBuilder<Chase>(
            watchThisProvider: streamChaseProvider(chaseId),
            logger: logger,
            showBackButton: true,
            builder: (chase, ref) {
              String? imageURL = chase.imageURL;

              return Column(
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
                        imageURL: imageURL,
                        logger: logger,
                        youtubeVideo: video,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
