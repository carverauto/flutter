import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/util/helpers/image_url_parser.dart';
import '../../../../shared/widgets/builders/image_builder.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import '../providers/providers.dart';
import 'mp4_player/mp4_player.dart';
import 'watch_youtube_video_button.dart';

class ChaseHeroSection extends ConsumerWidget {
  const ChaseHeroSection({
    Key? key,
    required this.chaseId,
    required this.imageURL,
    required this.youtubeVideo,
  }) : super(key: key);

  final String chaseId;
  final String? imageURL;
  final Widget youtubeVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ChaseNetwork>? networks =
        ref.watch(chaseNetworksStateProvider(chaseId));
    final List<ChaseNetwork> networksModifiable =
        networks == null ? [] : [...networks];

    // sort networks based on Tier value
    if (networksModifiable != null && networksModifiable.length >= 2) {
      networksModifiable
          .sort((ChaseNetwork a, ChaseNetwork b) => a.tier!.compareTo(b.tier!));
    }

    final bool? isLive = ref.watch(
      chaseLiveStatusChaseProvider(chaseId),
    );
    final String? chaseImageUrl = ref.watch(
      streamChaseProvider(chaseId)
          .select((AsyncValue<Chase> value) => value.value?.imageURL),
    );
    const bool isYoutubeUrlPresent = false;
    //     networksModifiable.any((ChaseNetwork network) {
    //   final String? url = network.url;

    //   if (url != null) {
    //     return isValidYoutubeUrl(url);
    //   }

    //   return false;
    // });
    String? mp4Url;
    if (!isYoutubeUrlPresent) {
      mp4Url =
          'http://nbclim-download.edgesuite.net/Prod/NBCU_LM_VMS_-_KNBC/948/803/19486677468-1080pnbcstations.mp4';
      networksModifiable
          .firstWhereOrNull(
            (ChaseNetwork network) =>
                network.mp4Url != null && network.mp4Url!.isNotEmpty,
          )
          ?.mp4Url;
    }

    return Stack(
      children: [
        if (isYoutubeUrlPresent)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final bool isPlayVideo = ref.watch(playVideoProvider);

              return isPlayVideo ? youtubeVideo : const SizedBox.shrink();
            },
          ),
        if (!isYoutubeUrlPresent && mp4Url == null)
          GestureDetector(
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
                  child: chaseImageUrl != null && chaseImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
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
                      child: WatchYoutubeVideo(isLive: isLive ?? false),
                    ),
                  ),
                Positioned(
                  left: kPaddingSmallConstant,
                  top: kPaddingSmallConstant,
                  child: ElevatedButton(
                    // shape: const CircleBorder(),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // show the mp4 video
        if (!isYoutubeUrlPresent && mp4Url != null)
          Mp4VideoPlayerView(
            mp4Url: mp4Url,
          ),
      ],
    );
  }
}

class ClosePlayingVideo extends ConsumerWidget {
  const ClosePlayingVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      // shape: const CircleBorder(),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
      ),
      onPressed: () {
        ref.read(playVideoProvider.state).update((bool state) => false);
      },
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }
}
