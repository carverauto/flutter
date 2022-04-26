import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../const/colors.dart';
import '../../../../const/sizings.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../shared/util/helpers/date_added.dart';
import '../../../../shared/util/helpers/dynamiclink_generator.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../../shared/widgets/sentiment_analysis_slider.dart';
import '../../../signin/view/parts/gradient_animation_container.dart';
import '../providers/providers.dart';
import 'chase_description_dialog.dart';
import 'chase_hero.dart';
import 'donut_clap_button.dart';
import 'watch_here_video.dart';

class ChaseDetails extends ConsumerStatefulWidget {
  const ChaseDetails({
    Key? key,
    required this.imageURL,
    required this.logger,
    required this.chase,
    required this.youtubeVideo,
    required this.onYoutubeNetworkTap,
    required this.chatsRow,
    required this.chatsView,
  }) : super(key: key);

  final String? imageURL;
  final Logger logger;
  final Chase chase;
  final Widget youtubeVideo;
  final Widget chatsRow;
  final Widget chatsView;
  final void Function(String url) onYoutubeNetworkTap;

  @override
  ConsumerState<ChaseDetails> createState() => _ChaseDetailsState();
}

class _ChaseDetailsState extends ConsumerState<ChaseDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (BuildContext context) {
            final bool isTyping = MediaQuery.of(context).viewInsets.bottom > 0;
            final num bottomPadding =
                isTyping ? MediaQuery.of(context).size.height * 0.15 : 0;
            final num extraSizing = isTyping ? kToolbarHeight : 0;

            return AnimatedContainer(
              height: MediaQuery.of(context).size.width * (9 / 16) -
                  bottomPadding +
                  extraSizing,
              width: double.maxFinite,
              duration: const Duration(milliseconds: 300),
              child: ChaseHeroSection(
                chase: widget.chase,
                imageURL: widget.imageURL,
                youtubeVideo: widget.youtubeVideo,
              ),
            );
          },
        ),
        Expanded(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final bool showChatsWindow =
                  ref.watch(isShowingChatsWindowProvide);

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: showChatsWindow ? widget.chatsView : child,
              );
            },
            child: ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Material(
                    child: InkWell(
                      onTap: () {
                        showDescriptionDialog(context, widget.chase);
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
                                widget.chase.name ?? 'NA',
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
                            const Icon(
                              Icons.expand_more,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                            const SizedBox(
                              width: kItemsSpacingSmallConstant / 2,
                            ),
                            if (widget.chase.live ?? false)
                              const RepaintBoundary(
                                child: GradientAnimationChildBuilder(
                                  shouldAnimate: true,
                                  padding: EdgeInsets.zero,
                                  child: GlassButton(
                                    child: Text(
                                      'Live!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              GlassButton(
                                child: Text(
                                  dateAdded(widget.chase),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: kItemsSpacingSmallConstant,
                        ),
                        if (widget.chase.endedAt != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                color: primaryColor.shade300,
                              ),
                              const SizedBox(
                                width: kItemsSpacingSmallConstant / 2,
                              ),
                              GlassButton(
                                child: Text(
                                  chaseDuration(
                                    widget.chase.createdAt!,
                                    widget.chase.endedAt!,
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: kItemsSpacingSmallConstant,
                        ),
                        Text(
                          'Sentiment Analysis :',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        const SizedBox(
                          height: kItemsSpacingExtraSmallConstant,
                        ),
                        SentimentSlider(chase: widget.chase),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              child: ButtonBar(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        final String shareLink =
                                            await createChaseDynamicLink(
                                          widget.chase,
                                          ref.read(
                                            firebaseDynamicLinksProvider,
                                          ),
                                        );
                                        await Share.share(shareLink);
                                      } catch (e, stk) {
                                        widget.logger.warning(
                                          'Chase Sharing Failed!',
                                          e,
                                          stk,
                                        );
                                      }
                                    },
                                    icon: const Icon(
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
                                chase: widget.chase,
                                logger: widget.logger,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: kItemsSpacingSmall,
                  ),
                  WatchHereLinksWrapper(
                    chase: widget.chase,
                    onYoutubeNetworkTap: widget.onYoutubeNetworkTap,
                  ),
                  Divider(
                    height: kItemsSpacingSmall,
                  ),
                  widget.chatsRow,
                ],
              ),
            ),
          ),

          //  Stack(
          //   children: [
          //     ,
          //     widget.chatsView,
          //   ],
          // ),
        ),
      ],
    );
  }
}
