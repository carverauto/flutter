import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../models/chase/network/chase_stream/chase_stream.dart';
import '../../../../shared/util/helpers/image_url_parser.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../shared/widgets/builders/image_builder.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import '../providers/providers.dart';
import 'mp4_player/mp4_player.dart';
import 'watch_youtube_video_button.dart';

class ChaseHeroSection extends ConsumerStatefulWidget {
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
  ConsumerState<ChaseHeroSection> createState() => _ChaseHeroSectionState();
}

class _ChaseHeroSectionState extends ConsumerState<ChaseHeroSection> {
  String? youtubeUrl;
  String? mp4Url;

  void sortOutNetworksBasedOnTier() {
    final List<ChaseNetwork>? chaseNetworks =
        ref.read(chaseNetworksStateProvider(widget.chaseId));
    final List<ChaseNetwork> networksModifiable =
        chaseNetworks == null ? [] : [...chaseNetworks];

    // sort networks based on Tier value
    if (networksModifiable == null || networksModifiable.isEmpty) {
      return;
    }
    if (networksModifiable.length >= 2) {
      networksModifiable
          .sort((ChaseNetwork a, ChaseNetwork b) => a.tier!.compareTo(b.tier!));
    }
    final List<ChaseStream> streams = List.empty(growable: true);

    for (final ChaseNetwork network in networksModifiable) {
      streams
        ..add(ChaseStream(tier: 0, url: network.url ?? ''))
        ..add(ChaseStream(tier: 0, url: network.mp4Url ?? ''));
      if (network.streams != null) {
        final List<ChaseStream> sortedStreams = network.streams!;
        if (sortedStreams.length >= 2) {
          sortedStreams
              .sort((ChaseStream a, ChaseStream b) => a.tier.compareTo(b.tier));
        }

        streams.addAll(sortedStreams);
      }
    }
    if (streams.isEmpty) {
      return;
    }

    youtubeUrl ??= streams.firstWhere((ChaseStream network) {
      final String url = network.url;

      if (url != null) {
        return isValidYoutubeUrl(url);
      }

      return false;
    }).url;

    mp4Url ??= streams.firstWhere((ChaseStream network) {
      final String url = network.url;

      if (url != null) {
        return url.endsWith('.mp4');
      }

      return false;
    }).url;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sortOutNetworksBasedOnTier();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    ref.listen<List<ChaseNetwork>?>(
      chaseNetworksStateProvider(widget.chaseId),
      (
        List<ChaseNetwork>? previous,
        List<ChaseNetwork>? next,
      ) {
        sortOutNetworksBasedOnTier();
      },
    );

    final bool? isLive = ref.watch(
      chaseLiveStatusChaseProvider(widget.chaseId),
    );
    final String? chaseImageUrl = ref.watch(
      streamChaseProvider(widget.chaseId)
          .select((AsyncValue<Chase> value) => value.value?.imageURL),
    );

    final bool isYoutubeUrlPresent = youtubeUrl != null;

    return Stack(
      children: [
        if (isYoutubeUrlPresent)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final bool isPlayVideo = ref.watch(playVideoProvider);

              return isPlayVideo
                  ? widget.youtubeVideo
                  : const SizedBox.shrink();
            },
          ),
        if (!isYoutubeUrlPresent && mp4Url == null)
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (isYoutubeUrlPresent) {
                    ref
                        .read(playVideoProvider.state)
                        .update((bool state) => true);
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
                                widget.imageURL!,
                                ImageDimensions.LARGE,
                              ),
                              placeholder: (
                                BuildContext context,
                                String value,
                              ) =>
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
                  ],
                ),
              ),
              Positioned(
                left: kPaddingSmallConstant,
                top: kPaddingSmallConstant,
                child: ElevatedButton(
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
        // show the mp4 video
        if (!isYoutubeUrlPresent && mp4Url != null)
          Mp4VideoPlayerView(
            mp4Url: mp4Url!,
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
