import 'package:flutter/material.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/sizings.dart';
import 'animations_overlay_toggle_switch.dart';
import 'mp4_player/mp4_player.dart';

class VideoTopActions extends StatefulWidget {
  const VideoTopActions({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final YoutubePlayerController controller;

  @override
  State<VideoTopActions> createState() => _VideoTopActionsState();
}

class _VideoTopActionsState extends State<VideoTopActions> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: kPaddingSmallConstant,
          right: kPaddingSmallConstant,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                popVideoView(context, widget.controller.toggleFullScreenMode);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const ChaseAppChromeCastButton(),
            const SizedBox(width: kPaddingSmallConstant),
            const AnimationsOverlayToggleSwitch(),
            SizedBox(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 68
                  : kItemsSpacingSmallConstant,
            ),
          ],
        ),
      ),
    );
  }
}

class ChaseAppChromeCastButton extends StatefulWidget {
  const ChaseAppChromeCastButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ChaseAppChromeCastButton> createState() =>
      _ChaseAppChromeCastButtonState();
}

class _ChaseAppChromeCastButtonState extends State<ChaseAppChromeCastButton> {
  late ChromeCastController _controller;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(kBorderRadiusStandard),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ChromeCastButton(
            size: kIconSizeLargeConstant,
            color: Colors.red,
            onButtonCreated: (ChromeCastController controller) {
              setState(() => _controller = controller);

              _controller.addSessionListener();
            },
            onSessionStarted: () {
              _controller.loadMedia(
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
              );
            },
          ),
          const IgnorePointer(
            child: Icon(Icons.cast),
          ),
        ],
      ),
    );
  }
}
