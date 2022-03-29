import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../providers/providers.dart';
import 'pop_up_animations_overlay.dart';
import 'theater_rive.dart';

class VideoAnimationsOverlay extends ConsumerWidget {
  const VideoAnimationsOverlay({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final YoutubePlayerController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showOverlay = ref.watch(showVideoOverlayProvider);

    return !showOverlay
        ? const SizedBox.shrink()
        : Stack(
            fit: StackFit.expand,
            children: [
              const Align(
                alignment: Alignment.bottomCenter,
                child: TheaterRive(),
              ),
              PopupAnimationsView(
                controller: controller,
              ),
              Positioned(
                top: kItemsSpacingSmallConstant,
                left: kItemsSpacingSmallConstant,
                child: Image(
                  image: const AssetImage(chaseAppTextLogoAsset),
                  height: kImageSizeSmall,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          );
  }
}
