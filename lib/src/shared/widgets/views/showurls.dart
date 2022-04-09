import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../../const/colors.dart';
import '../../../const/images.dart';
import '../../../const/sizings.dart';
import '../../../models/chase/network/chase_network.dart';
import '../../util/helpers/launchLink.dart';
import '../buttons/glass_button.dart';

class URLView extends ConsumerWidget {
  const URLView({
    Key? key,
    required this.networks,
    this.onYoutubeNetworkTap,
  }) : super(key: key);
  final List<ChaseNetwork> networks;
  final void Function(String url)? onYoutubeNetworkTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: kButtonHeightSmall,
      child: ListView(
        // spacing: kItemsSpacingSmallConstant,
        // runSpacing: kItemsSpacingSmallConstant,
        scrollDirection: Axis.horizontal,

        children: networks.map<Widget>((ChaseNetwork data) {
          final String? url = data.url;
          final String? name = data.name;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kItemsSpacingExtraSmallConstant,
            ),
            child: GlassButton(
              padding: const EdgeInsets.all(kPaddingSmallConstant),
              onTap: () async {
                if (url != null) {
                  if (onYoutubeNetworkTap != null) {
                    onYoutubeNetworkTap!(url);
                  } else {
                    await launchUrl(url);
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor.shade300,
                    backgroundImage: NetworkImage(getNetworkLogUrl(url)),
                  ),
                  const SizedBox(
                    width: kItemsSpacingExtraSmallConstant,
                  ),
                  Text(
                    toBeginningOfSentenceCase(name) ?? 'NA',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

String getNetworkLogUrl(String? url) {
  if (url == null) {
    return defaultPhotoURL;
  }
  // parse the url to get the hose from it. match it agains the keys in the networkUrls
  final String hostName = Uri.parse(url).host.replaceAll('www.', '');
  final String? network = networkUrls.entries
      .firstWhereOrNull(
        (MapEntry<String, String> entry) => entry.key.contains(hostName),
      )
      ?.value;

  return network != null ? 'https://chaseapp.tv/$network' : defaultPhotoURL;
}

Map<String, String> networkUrls = {
  'foxla.com': '/networks/foxla.jpg',
  'losangeles.cbslocal.com': '/networks/cbsla.jpg',
  'nbclosangeles.com': '/networks/nbclosangeles.jpg',
  'abc7.com': '/networks/abc7.jpg',
  'ktla.com': '/networks/ktla.jpg',
  'broadcastify.com': '/networks/broadcastify.jpg',
  'audio12.broadcastify.com': '/networks/broadcastify.jpg',
  'facebook.com': '/networks/facebook.jpg',
  'm.facebook.com': '/networks/facebook.jpg',
  'wsvn.com': '/networks/wsvn.jpg',
  'twitter.com': '/Twitter_logo_blue_32.png',
  'nbcmiami.com': '/networks/nbc6.jpg',
  'iheart.com': '/networks/iheart.jpg',
  'kdoc.tv': '/networks/kdoc.jpg',
  'youtube.com': '/networks/youtube.jpg',
  'youtu.be': '/networks/youtube.jpg',
  'pscp.tv': '/networks/periscope.png',
  'fox10phoenix.com': '/networks/fox10.png',
  'kfor.com': '/networks/kfor.jpg',
  'kctv5.com': '/networks/kctv5.jpg',
  'fox4news.com': '/networks/fox4.jpg',
  'nbcdfw.com': '/networks/nbcdfw.jpg',
  'khou.com': '/networks/khou.jpg',
  'wesh.com': '/networks/wesh.jpg',
  'cbs8.com': '/networks/cbs8.png',
  'abc13.com': '/networks/abc13.png',
  'wsoctv.com': '/networks/wsoc.png',
  'news9.com': '/networks/news9.jpg',
};
