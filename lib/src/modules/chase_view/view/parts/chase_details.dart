import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_description_dialog.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_hero.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/donut_clap_button.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/watch_here_video.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/modules/chats/view/pages/chats_row_view.dart';
import 'package:chaseapp/src/modules/signin/view/parts/gradient_animation_container.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/dynamiclink_generator.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:chaseapp/src/shared/widgets/sentiment_analysis_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

class ChaseDetails extends ConsumerWidget {
  ChaseDetails({
    Key? key,
    required this.imageURL,
    required this.logger,
    required this.chase,
    required this.youtubeVideo,
  }) : super(key: key);

  final String? imageURL;
  final Logger logger;
  final Chase chase;
  final Widget youtubeVideo;
  final GlobalKey chaseDetailsKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (chaseDetailsKey.currentContext != null) {
        final renderbox =
            chaseDetailsKey.currentContext!.findRenderObject() as RenderBox;
        final height = renderbox.size.height;
        final finalHeight = ref.read(chaseDetailsHeightProvider);
        if (finalHeight == null) {
          ref.read(chaseDetailsHeightProvider.state).update((state) => height);
        }
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChaseHeroSection(
          chase: chase,
          imageURL: imageURL,
          youtubeVideo: youtubeVideo,
        ),
        Expanded(
          key: chaseDetailsKey,
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Material(
                  child: InkWell(
                    onTap: () {
                      showDescriptionDialog(context, chase);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPaddingMediumConstant,
                        vertical: kPaddingSmallConstant,
                      ),
                      child: Row(
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
                          Icon(
                            Icons.expand_more,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: kItemsSpacingSmallConstant,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPaddingMediumConstant,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          if (chase.live ?? false)
                            GradientAnimationChildBuilder(
                              shouldAnimate: true,
                              padding: EdgeInsets.all(0),
                              child: GlassButton(
                                child: Text(
                                  "Live!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          else
                            GlassButton(
                              child: Text(
                                dateAdded(chase),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: kItemsSpacingSmallConstant,
                      ),
                      Text(
                        "Sentiment Analysis :",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      SizedBox(
                        height: kItemsSpacingExtraSmallConstant,
                      ),
                      SentimentSlider(chase: chase),
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
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: Icon(
                                //     Icons.bookmark_border,
                                //   ),
                                // ),
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
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                WatchHereLinksWrapper(chase: chase),
                Divider(
                  height: kItemsSpacingSmall,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                ChatsViewRow(chase: chase)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
