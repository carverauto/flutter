import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/network/chase_network.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class URLView extends ConsumerWidget {
  final List<ChaseNetwork> networks;

  const URLView(
    this.networks,
    this.onYoutubeNetworkTap,
  );

  final void Function(String url)? onYoutubeNetworkTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: kItemsSpacingSmallConstant,
      runSpacing: kItemsSpacingSmallConstant,
      children: networks.map<Widget>((data) {
        final String? url = data.url;
        final String? name = data.name;
        return GlassButton(
          padding: EdgeInsets.all(kPaddingSmallConstant),
          onTap: () async {
            if (url != null) {
              if (onYoutubeNetworkTap != null) {
                onYoutubeNetworkTap!(url);
              } else {
                launchUrl(url);
              }
            }
          },
          child: Text(
            name ?? "NA",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        );
      }).toList(),
    );
  }
}
