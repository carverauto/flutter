import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/aspect_ratio.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_description_dialog.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/donut_clap_button.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/show_chats_dialog.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/dynamiclink_generator.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:chaseapp/src/shared/widgets/sentiment_analysis_slider.dart';
import 'package:chaseapp/src/shared/widgets/views/showurls.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

class ChaseDetails extends StatelessWidget {
  const ChaseDetails({
    Key? key,
    required this.imageURL,
    required this.logger,
    required this.chase,
  }) : super(key: key);

  final String? imageURL;
  final Logger logger;
  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: aspectRatioStandard,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.primaryVariant,
            child: chase.imageURL != null && chase.imageURL!.isNotEmpty
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: parseImageUrl(
                      imageURL!,
                      ImageDimensions.LARGE,
                    ),
                    placeholder: (context, value) =>
                        CircularAdaptiveProgressIndicatorWithBg(),
                    errorWidget: (context, value, dynamic value2) {
                      return ImageLoadErrorWidget();
                    },
                  )
                : Image(
                    fit: BoxFit.cover,
                    image: AssetImage(defaultChaseImage),
                  ),
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingMediumConstant,
                    vertical: kPaddingSmallConstant,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              chase.name ?? "NA",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                          ),
                          IconButton(
                            tooltip: "Show Description",
                            onPressed: () {
                              showDescriptionDialog(context, chase);
                            },
                            icon: Icon(
                              Icons.expand_more,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.alarm,
                            color: primaryColor.shade300,
                          ),
                          SizedBox(
                            width: kItemsSpacingSmallConstant / 2,
                          ),
                          Text(
                            dateAdded(chase),
                            style: TextStyle(
                              color: primaryColor.shade300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: kItemsSpacingSmallConstant,
                      ),
                      Text(
                        "Sentiment Analysis",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      SentimentSlider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            child: ButtonBar(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      final shareLink =
                                          await createChaseDynamicLink(chase);
                                      Share.share(shareLink);
                                    } catch (e, stk) {
                                      logger.warning(
                                        "Chase Sharing Failed!",
                                        e,
                                        stk,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.share,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.bookmark_border,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: DonutClapButton(
                              chase: chase,
                              logger: logger,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: kItemsSpacingSmall,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
                WatchHereLinksWrapper(chase: chase),
                Divider(
                  height: kItemsSpacingSmall,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingMediumConstant,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chats :",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      //     decoration: TextDecoration.underline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                          ),
                          IconButton(
                            onPressed: () {
                              showChatsDialog(context, chase);
                            },
                            icon: Icon(
                              Icons.expand,
                            ),
                          )
                        ],
                      ),
                      Placeholder(
                        fallbackHeight: 50,
                      ),
                      SizedBox(
                        height: kItemsSpacingLargeConstant,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WatchHereLinksWrapper extends StatelessWidget {
  const WatchHereLinksWrapper({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMediumConstant,
        vertical: kPaddingSmallConstant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Watch here :",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  //  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          SizedBox(
            height: kItemsSpacingSmallConstant,
          ),
          chase.networks != null
              ? URLView(chase.networks as List<Map>)
              : const Text('Please wait..'),
        ],
      ),
    );
  }
}
