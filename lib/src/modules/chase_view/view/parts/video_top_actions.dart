import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/sizings.dart';
import 'animations_overlay_toggle_switch.dart';
import 'mp4_player/mp4_player.dart';

class VideoTopActions extends StatelessWidget {
  const VideoTopActions({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final YoutubePlayerController controller;

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
                popVideoView(context, controller.toggleFullScreenMode);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Spacer(),
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
