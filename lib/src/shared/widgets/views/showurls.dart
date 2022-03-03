import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class URLView extends ConsumerWidget {
  final List<Map> streams;

  const URLView(
    this.streams,
    this.onYoutubeNetworkTap,
  );

  final void Function(String url)? onYoutubeNetworkTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: kItemsSpacingSmallConstant,
      runSpacing: kItemsSpacingSmallConstant,
      children: streams.map<Widget>((data) {
        final String url = data["URL"] as String;
        final String name = data["Name"] as String;
        return GlassButton(
          padding: EdgeInsets.all(kPaddingSmallConstant),
          onTap: () async {
            if (onYoutubeNetworkTap != null) {
              onYoutubeNetworkTap!(url);
            } else {
              launchUrl(url);
            }
          },
          child: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        );
      }).toList(),
    );
  }
}
