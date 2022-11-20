import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
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
import 'mp4_player/providers.dart';
import 'watch_youtube_video_button.dart';
import 'youtube_player/youtube_player_view.dart';

class ChaseHeroSection extends ConsumerStatefulWidget {
  const ChaseHeroSection({
    Key? key,
    required this.chaseId,
    required this.imageURL,
  }) : super(key: key);

  final String chaseId;
  final String? imageURL;

  @override
  ConsumerState<ChaseHeroSection> createState() => _ChaseHeroSectionState();
}

class _ChaseHeroSectionState extends ConsumerState<ChaseHeroSection> {
  String? youtubeUrl;
  String? mp4Url;

  // ignore: long-method
  void sortOutNetworksBasedOnTier() {
    if (youtubeUrl != null || mp4Url != null) {
      return;
    }
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
          .sort((ChaseNetwork a, ChaseNetwork b) => b.tier!.compareTo(a.tier!));
    }

    for (final ChaseNetwork network in networksModifiable) {
      final List<ChaseStream> streams = List.empty(growable: true);

      final List<ChaseStream> networkStreams = <ChaseStream>[
        ChaseStream(tier: 0, url: network.url ?? ''),
        ChaseStream(tier: 0, url: network.mp4Url ?? ''),
      ];
      if (network.streams != null) {
        final List<ChaseStream> sortedStreams =
            List<ChaseStream>.from(network.streams!);
        if (sortedStreams.length >= 2) {
          sortedStreams
              .sort((ChaseStream a, ChaseStream b) => b.tier.compareTo(a.tier));
        }

        sortedStreams.insertAll(
          0,
          networkStreams,
        );
        streams.addAll(sortedStreams);
      } else {
        streams.addAll(networkStreams);
      }
      youtubeUrl ??= streams.firstWhereOrNull((ChaseStream network) {
        final String url = network.url;

        if (url != null) {
          return isValidYoutubeUrl(url);
        }

        return false;
      })?.url;
      if (youtubeUrl != null) {
        ref
            .read(currentlyPlayingVideoUrlProvider.state)
            .update((String? state) => youtubeUrl);
        break;
      }

      mp4Url ??= streams.firstWhereOrNull((ChaseStream network) {
        final String url = network.url;

        if (url != null) {
          return url.endsWith('.mp4');
        }

        return false;
      })?.url;
      if (mp4Url != null) {
        ref
            .read(currentlyPlayingVideoUrlProvider.state)
            .update((String? state) => mp4Url);
        break;
      }
    }

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

    ref.listen<String?>(
      mp4PlauerPlayEventsStreamProovider,
      (String? prev, String? next) {
        if (next != null) {
          setState(
            () {
              youtubeUrl = null;
              mp4Url = next;
            },
          );
        }
      },
    );
    ref.listen<String?>(
      youtubePlauerPlayEventsStreamProovider,
      (String? prev, String? next) {
        if (next != null) {
          setState(
            () {
              youtubeUrl = next;
              mp4Url = null;
            },
          );
        }
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
              final Chase? chase = ref
                  .read(
                    streamChaseProvider(widget.chaseId),
                  )
                  .value;

              return YoutubePlayerView(
                url: youtubeUrl!,
                isLive: isLive ?? false,
                chase: chase!,
              );
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
