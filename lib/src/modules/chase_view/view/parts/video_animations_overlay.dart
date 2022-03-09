import 'package:chaseapp/src/const/images.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/theater_rive.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoAnimationsOverlay extends ConsumerWidget {
  const VideoAnimationsOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showOverlay = ref.watch(showVideoOverlayProvider);
    return !showOverlay
        ? SizedBox.shrink()
        : Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: kItemsSpacingSmallConstant,
                left: kItemsSpacingSmallConstant,
                child: Image(
                  image: AssetImage(chaseAppTextLogoAsset),
                  height: kImageSizeSmall,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TheaterRive(),
              )
            ],
          );
  }
}
