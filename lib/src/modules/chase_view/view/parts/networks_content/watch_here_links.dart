// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../const/sizings.dart';
import '../../../../../models/chase/network/chase_network.dart';
import '../../../../../models/chase/network/chase_stream/chase_stream.dart';
import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../providers/providers.dart';
import 'showurls.dart';

class WatchHereLinksWrapper extends ConsumerWidget {
  const WatchHereLinksWrapper({
    Key? key,
    required this.chaseId,
  }) : super(key: key);

  final String chaseId;

  // ignore: long-method
  NetworkContentMapped getNetworkContentedMap(
    ChaseNetwork network,
    bool isStreams,
  ) {
    final List<ChaseStream> streams =
        List.from(network.streams ?? <ChaseStream>[]);
    if (network.url != null) {
      streams.add(ChaseStream(tier: 0, url: network.url!));
    }
    if (network.mp4Url != null) {
      streams.add(ChaseStream(tier: 0, url: network.mp4Url!));
    }

    if (isStreams) {
      final List<ChaseStream> youtubeStreams = isStreams
          ? streams.where((ChaseStream network) {
              final String url = network.url;
              if (url != null) {
                final bool isYoutube = isValidYoutubeUrl(url);

                return isYoutube;
              }
              return false;
            }).toList()
          : [];

      final List<ChaseStream> mp4Networks = isStreams
          ? streams.where((ChaseStream network) {
              final String url = network.url;
              if (url != null) {
                final bool isMp4 = url.endsWith('.mp4');
                return isMp4;
              }
              return false;
            }).toList()
          : [];
      streams
        ..addAll(youtubeStreams)
        ..addAll(mp4Networks);

      return NetworkContentMapped(
        network: network,
        youtubeStreams: youtubeStreams,
        mp4Streams: mp4Networks,
      );
    } else {
      final List<ChaseStream> otherNetworks = !isStreams
          ? streams.where((ChaseStream network) {
              final String url = network.url;

              if (url != null) {
                final bool isYoutube = isValidYoutubeUrl(url);

                return !isYoutube && !url.endsWith('.mp4');
              }

              return false;
            }).toList()
          : [];
      streams.addAll(otherNetworks);

      return NetworkContentMapped(
        network: network,
        others: otherNetworks,
      );
    }
  }

  List<NetworkContentMapped> mappedNetworkContent(
    List<ChaseNetwork> networks,
    bool isStreams,
  ) {
    final List<NetworkContentMapped> streams = [];
    for (final ChaseNetwork network in networks) {
      final NetworkContentMapped networkContentMapped = getNetworkContentedMap(
        network,
        isStreams,
      );
      if (isStreams) {
        if (networkContentMapped.youtubeStreams.isNotEmpty ||
            networkContentMapped.mp4Streams.isNotEmpty) {
          streams.add(networkContentMapped);
        }
      } else {
        if (networkContentMapped.others.isNotEmpty) {
          streams.add(networkContentMapped);
        }
      }
    }

    return streams;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ChaseNetwork>? networks = ref.watch(
      chaseNetworksStateProvider(chaseId),
    );
    final List<ChaseNetwork> sortedNetworks = [...?networks]..sort(
        (ChaseNetwork a, ChaseNetwork b) => b.tier!.compareTo(a.tier!),
      );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMediumConstant,
        vertical: kPaddingSmallConstant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NetworksList(
            networkContentMap: mappedNetworkContent(sortedNetworks, true),
            iStreams: true,
          ),
          const SizedBox(
            height: kItemsSpacingSmallConstant,
          ),
          _NetworksList(
            networkContentMap: mappedNetworkContent(sortedNetworks, false),
            iStreams: false,
          ),
        ],
      ),
    );
  }
}

class _NetworksList extends StatelessWidget {
  const _NetworksList({
    Key? key,
    required this.networkContentMap,
    required this.iStreams,
  }) : super(key: key);

  final List<NetworkContentMapped> networkContentMap;
  final bool iStreams;

  @override
  Widget build(BuildContext context) {
    return networkContentMap.isEmpty
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    iStreams ? Icons.play_arrow_rounded : Icons.link_rounded,
                    color: iStreams ? Colors.white : Colors.blue,
                  ),
                  const SizedBox(
                    width: kPaddingXSmallConstant,
                  ),
                  Text(
                    iStreams ? 'Streams' : 'Other',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          //  decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: kItemsSpacingSmallConstant,
              ),
              URLView(
                networkContentMap: networkContentMap,
                isStreams: iStreams,
              ),
            ],
          );
  }
}

class NetworkContentMapped {
  NetworkContentMapped({
    required this.network,
    this.youtubeStreams = const [],
    this.mp4Streams = const [],
    this.others = const [],
  });

  final ChaseNetwork network;
  final List<ChaseStream> youtubeStreams;
  final List<ChaseStream> mp4Streams;
  final List<ChaseStream> others;
}
