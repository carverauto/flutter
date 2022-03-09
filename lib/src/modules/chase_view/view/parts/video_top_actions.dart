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
              if (MediaQuery.of(context).orientation == Orientation.portrait)
                ClosePlayingVideo(),
              PopupMenuButton<int>(
                offset: Offset(0, 50),
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    child: Row(
                      children: [
                        Text(
                          "Animations",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: kItemsSpacingSmallConstant),
                        AnimationsOverlayToggleSwitch(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
