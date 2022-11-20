import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../shared/widgets/views/showurls.dart';
import '../providers/providers.dart';

class WatchHereLinksWrapper extends ConsumerWidget {
  const WatchHereLinksWrapper({
    Key? key,
    required this.chaseId,
  }) : super(key: key);

  final String chaseId;

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
          NetworksList(
            networks: sortedNetworks,
            iStreams: true,
          ),
          const SizedBox(
            height: kItemsSpacingSmallConstant,
          ),
          NetworksList(
            networks: sortedNetworks,
            iStreams: false,
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
    required this.iStreams,
  }) : super(key: key);

  final List<ChaseNetwork>? networks;
  final bool iStreams;

  @override
  Widget build(BuildContext context) {
    return networks == null || networks!.isEmpty
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
                    "${iStreams ? "Streams" : "Other"} :",
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
              if (networks != null)
                URLView(
                  networks: networks!,
                  isStreams: iStreams,
                )
              else
                const Text('Please wait..'),
            ],
          );
  }
}
