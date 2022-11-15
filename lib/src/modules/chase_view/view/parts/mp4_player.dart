import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.mp4Url,
    );
    _controller.initialize().then((value) {
      setState(() {
        _controller.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
