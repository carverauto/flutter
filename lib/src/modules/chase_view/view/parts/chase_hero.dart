import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/images.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/util/helpers/image_url_parser.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../shared/widgets/builders/image_builder.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import '../providers/providers.dart';
import 'watch_youtube_video_button.dart';

class ChaseHeroSection extends ConsumerWidget {
  const ChaseHeroSection({
    Key? key,
    required this.chase,
    required this.imageURL,
    required this.youtubeVideo,
  }) : super(key: key);

  final Chase chase;
  final String? imageURL;
  final Widget youtubeVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool playVideo = ref.watch(playVideoProvider);
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = bottomPadding > 0;
    final bool isYoutubeUrlPresent =
        chase.networks?.any((ChaseNetwork network) {
              final String? url = network.url;

              if (url != null) {
                return isValidYoutubeUrl(url);
              }

              return false;
            }) ??
            false;

    return playVideo
        ? youtubeVideo
        : GestureDetector(
            onTap: () {
              if (isYoutubeUrlPresent) {
                ref.read(playVideoProvider.state).update((bool state) => true);
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: chase.imageURL != null && chase.imageURL!.isNotEmpty
                      ? CachedNetworkImage(
                          fit: isKeyboardVisible ? BoxFit.cover : BoxFit.fill,
                          maxWidthDiskCache: 750,
                          maxHeightDiskCache: 421,
                          memCacheHeight: 421,
                          memCacheWidth: 750,
                          imageUrl: parseImageUrl(
                            imageURL!,
                            ImageDimensions.LARGE,
                          ),
                          placeholder: (BuildContext context, String value) =>
                              const CircularAdaptiveProgressIndicatorWithBg(),
                          errorWidget: (
                            BuildContext context,
                            String value,
                            dynamic value2,
                          ) {
                            return const ImageLoadErrorWidget();
                          },
                        )
                      : const Image(
                          fit: BoxFit.cover,
                          image: AssetImage(defaultAssetChaseImage),
                        ),
                ),
                if (isYoutubeUrlPresent)
                  Align(
                    child: RepaintBoundary(
                      child: WatchYoutubeVideo(isLive: chase.live ?? false),
                    ),
                  ),
              ],
            ),
          );
  }
}

class ClosePlayingVideo extends ConsumerWidget {
  const ClosePlayingVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassButton(
      shape: const CircleBorder(),
      onTap: () {
        ref.read(playVideoProvider.state).update((bool state) => false);
      },
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }
}
