import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class AboutUsView extends ConsumerStatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  ConsumerState<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends ConsumerState<AboutUsView> {
  final Logger logger = Logger("About");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: kElevation,
        title: Image.asset(
          chaseAppNameImage,
          height: kImageSizeLarge,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ProviderStateBuilder<UserData>(
              watchThisProvider: userStreamProvider,
              logger: logger,
              builder: (user) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingMediumConstant,
                      vertical: kPaddingMediumConstant,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(child: new Text(
                              'This app captures device location and bluetooth scan data at regular intervals.\n\nChaseApp earns a small fee based on the quality of data that is uploaded.\n\nWhen the app is closed or not in use, location and bluetooth scan data may be captured in the background depending on the user-selected mode.',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            )),
                          ],
                        ),
                        Divider(
                          height: kItemsSpacingLarge,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
