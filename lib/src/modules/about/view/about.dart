import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../const/info.dart';
import '../../../const/links.dart';
import '../../../const/sizings.dart';
import '../../../shared/util/helpers/launchLink.dart';
import '../../dashboard/view/parts/chaseapp_appbar.dart';

class AboutUsView extends ConsumerStatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends ConsumerState<AboutUsView> {
  final Logger logger = Logger('About');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: kElevation,
        title: const Text('About us'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPaddingMediumConstant,
              vertical: kPaddingMediumConstant,
            ),
            child: Column(
              children: const [
                ChaseAppLogoImage(),
                SizedBox(
                  height: kPaddingMediumConstant,
                ),
                Text(
                  chaseAppMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(
            height: kItemsSpacingLargeConstant,
          ),
          TextButton(
            onPressed: () {
              launchUrl(chaseAppWebsite);
            },
            child: Text(
              'Visit Us',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
