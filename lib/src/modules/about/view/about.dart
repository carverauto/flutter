import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class AboutUsView extends ConsumerStatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends ConsumerState<AboutUsView> {
  final Logger logger = Logger("About");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: kElevation,
        title: Text("About us"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPaddingMediumConstant,
              vertical: kPaddingMediumConstant,
            ),
            child: Text(
              'This app captures device location and bluetooth scan data at regular intervals.\n\nChaseApp earns a small fee based on the quality of data that is uploaded.\n\nWhen the app is closed or not in use, location and bluetooth scan data may be captured in the background depending on the user-selected mode.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Spacer(),
          Divider(
            height: kItemsSpacingLargeConstant,
          ),
          TextButton(
            onPressed: () {
              launchUrl(chaseAppWebsite);
            },
            child: Text(
              "Visit Us",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          )
        ],
      ),
    );
  }
}
