import 'dart:core';
import 'dart:developer';

import 'package:chaseapp/src/const/aspect_ratio.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/util/helpers/dynamiclink_generator.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/buttons/medium_clap_flutter.dart';
import 'package:chaseapp/src/shared/widgets/views/showurls.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

// import 'package:chaseapp/pages/chat_page.dart';

class ShowChase extends ConsumerWidget {
  // ShowChase(this.observer);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final String chaseId;

  ShowChase({Key? key, required this.chaseId}) : super(key: key);

  final Logger logger = Logger("ChaseView");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        title: Image.asset(
          chaseAppNameImage,
          height: kImageSizeLarge,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final chase = await ref.read(streamChaseProvider(chaseId).future);

              try {
                final shareLink = await createRecordDynamicLink(chase);
                Share.share(shareLink);
              } catch (e) {
                log("Wha'ts wrong?", error: e);
              }

              // //TODO:Need to share a dynamic link or web link for the chase
              // Share.share(shareLink);
            },
          ),
        ],
      ),
      body: ProviderStateBuilder<Chase>(
        watchThisProvider: streamChaseProvider(chaseId),
        logger: logger,
        builder: (chase) {
          String? imageURL = chase.imageURL;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: aspectRatioStandard,
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  child: AdaptiveImageBuilder(
                    url: parseImageUrl(imageURL),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingMediumConstant,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: kItemsSpacingMedium,
                            ),
                            Text(
                              chase.name ?? "NA",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Divider(
                              height: kItemsSpacingSmall,
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                            ),
                            Flexible(
                              child: Text(
                                chase.desc ?? "NA",
                                style: Theme.of(context).textTheme.bodyText1!,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: kItemsSpacingSmall,
                      ),
                      Divider(
                        height: kItemsSpacingSmall,
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                      Text(
                        "Watch here :",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                      Expanded(
                        child: chase.networks != null
                            ? URLView(chase.networks as List<Map>)
                            : const Text('Please wait..'),
                      ),
                      // Spacer(),
                      SizedBox(
                        height: kItemsSpacingMedium,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ClapFAB.image(
                          trailing: Text(
                            chase.votes.toString(),
                            style: Theme.of(context).textTheme.headline5!,
                          ),
                          clapFabCallback: (int counter) async {
                            try {
                              //TODO: Improve this handling
                              ref.read(chaseRepoProvider).upVoteChase(chase.id);
                            } catch (e, stk) {
                              logger.warning(
                                "Error while upvoting a Chase",
                                e,
                                stk,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Something went wrong. Please try again later.',
                                  ),
                                ),
                              );
                            }
                          },
                          defaultImage: donutImage,
                          filledImage: donutImage,
                          countCircleColor: Colors.pink,
                          hasShadow: true,
                          sparkleColor: Colors.red,
                          shadowColor: Colors.pink,
                          defaultImageColor: Colors.pink,
                          filledImageColor: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: kItemsSpacingMedium,
              )
            ],
          );
        },
      ),
    );
  }
}
