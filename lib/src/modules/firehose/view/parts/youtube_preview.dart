import 'dart:core';

import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePreview extends ConsumerStatefulWidget {
  const YoutubePreview({
    Key? key,
    required this.videoId,
  }) : super(key: key);
  final String videoId;

  @override
  ConsumerState<YoutubePreview> createState() => _YoutubePreviewState();
}

class _YoutubePreviewState extends ConsumerState<YoutubePreview> {
  final bool expandChats = false;

  late YoutubePlayerController _controller;

  YoutubePlayerController initializeVideoController({String? youtubeUrl}) {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
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
    return Container(
      height: double.maxFinite,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
                video,
              ],
            ),
          );
        },
      ),
    );
  }
}
