import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/animations_overlay_toggle_switch.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_hero.dart';
import 'package:flutter/material.dart';

class VideoTopActions extends StatelessWidget {
  const VideoTopActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
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
              AnimationsOverlayToggleSwitch(),
              SizedBox(
                width: kItemsSpacingSmallConstant,
              ),
              if (MediaQuery.of(context).orientation == Orientation.portrait)
                ClosePlayingVideo(),
            ],
          ),
        ),
      ),
    );
  }
}
