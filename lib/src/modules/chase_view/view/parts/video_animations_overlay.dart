import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../providers/providers.dart';
import 'theater_rive.dart';

class VideoAnimationsOverlay extends ConsumerWidget {
  const VideoAnimationsOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showOverlay = ref.watch(showVideoOverlayProvider);

    return !showOverlay
        ? const SizedBox.shrink()
        : Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: kItemsSpacingSmallConstant,
                left: kItemsSpacingSmallConstant,
                child: Image(
                  image: const AssetImage(chaseAppTextLogoAsset),
                  height: kImageSizeSmall,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: TheaterRive(),
              ),
            ],
          );
  }
}
