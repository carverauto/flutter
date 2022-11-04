import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../shared/widgets/views/showurls.dart';
import '../providers/providers.dart';

class WatchHereLinksWrapper extends ConsumerWidget {
  const WatchHereLinksWrapper({
    Key? key,
    required this.chaseId,
    required this.onYoutubeNetworkTap,
  }) : super(key: key);

  final String chaseId;
  final void Function(String url) onYoutubeNetworkTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ChaseNetwork>? networks = ref.watch(
      chaseNetworksStateProvider(chaseId),
    );
    final List<ChaseNetwork>? youtubeNetworks =
        networks?.where((ChaseNetwork network) {
      final String? url = network.url;
      if (url != null) {
        final bool isYoutube = isValidYoutubeUrl(url);
        return isYoutube;
      }
      return false;
    }).toList();

    final List<ChaseNetwork>? otherNetworks =
        networks?.where((ChaseNetwork network) {
      final String? url = network.url;

      if (url != null) {
        final bool isYoutube = isValidYoutubeUrl(url);
        return !isYoutube;
      }
      return false;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMediumConstant,
        vertical: kPaddingSmallConstant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworksList(
            networks: youtubeNetworks,
            onYoutubeNetworkTap: onYoutubeNetworkTap,
          ),
          const SizedBox(
            height: kItemsSpacingSmallConstant,
          ),
          NetworksList(
            networks: otherNetworks,
          ),
        ],
      ),
    );
  }
}

class NetworksList extends StatelessWidget {
  const NetworksList({
    Key? key,
    required this.networks,
    this.onYoutubeNetworkTap,
  }) : super(key: key);

  final List<ChaseNetwork>? networks;
  final void Function(String url)? onYoutubeNetworkTap;

  @override
  Widget build(BuildContext context) {
    return networks == null || networks!.isEmpty
        ? const SizedBox.shrink()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${onYoutubeNetworkTap != null ? "Streams" : "Other"} :",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      //  decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              const SizedBox(
                height: kItemsSpacingSmallConstant,
              ),
              if (networks != null)
                URLView(
                  networks: networks!,
                  onYoutubeNetworkTap: onYoutubeNetworkTap,
                )
              else
                const Text('Please wait..'),
            ],
          );
  }
}
