import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';

class URLView extends StatelessWidget {
  final List<Map> streams;

  const URLView(this.streams);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: kItemsSpacingSmallConstant,
      runSpacing: kItemsSpacingSmallConstant,
      children: streams.map<Widget>((data) {
        final String url = data["URL"] as String;
        return GlassButton(
          padding: EdgeInsets.all(kPaddingSmallConstant),
          onTap: () {
            launchUrl(url);
          },
          child: Text(
            Uri.parse(url).host.replaceFirst("www.", ""),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        );
      }).toList(),
    );
  }
}
