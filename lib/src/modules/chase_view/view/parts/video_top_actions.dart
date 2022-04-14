import 'package:flutter/material.dart';

import '../../../../const/sizings.dart';
import 'animations_overlay_toggle_switch.dart';
import 'chase_hero.dart';

class VideoTopActions extends StatelessWidget {
  const VideoTopActions({
    Key? key,
  }) : super(key: key);

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
            const AnimationsOverlayToggleSwitch(),
            const SizedBox(
              width: kItemsSpacingSmallConstant,
            ),
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              const ClosePlayingVideo(),
          ],
        ),
      ),
    );
  }
}
