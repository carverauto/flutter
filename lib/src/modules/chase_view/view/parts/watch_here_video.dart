import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/chase/network/chase_network.dart';
import 'package:chaseapp/src/shared/util/helpers/is_valid_youtube_url.dart';
import 'package:chaseapp/src/shared/widgets/views/showurls.dart';
import 'package:flutter/material.dart';

class WatchHereLinksWrapper extends StatelessWidget {
  const WatchHereLinksWrapper({
    Key? key,
    required this.chase,
    required this.onYoutubeNetworkTap,
  }) : super(key: key);

  final Chase chase;
  final void Function(String url) onYoutubeNetworkTap;

  @override
  Widget build(BuildContext context) {
    final youtubeNetworks = chase.networks?.where((network) {
      final String? url = network.url;
      if (url != null) {
        final bool isYoutube = isValidYoutubeUrl(url);
        return isYoutube;
      }
      return false;
    }).toList();

    final otherNetworks = chase.networks?.where((network) {
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
          SizedBox(
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
        ? SizedBox.shrink()
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
              SizedBox(
                height: kItemsSpacingSmallConstant,
              ),
              networks != null
                  ? URLView(networks!, onYoutubeNetworkTap)
                  : const Text('Please wait..'),
            ],
          );
  }
}
