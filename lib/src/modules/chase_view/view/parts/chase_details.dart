import 'dart:developer';

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
        ChaseHeroSectionBuilder(
          chase: widget.chase,
          imageUrl: widget.imageURL,
          youtubeVideo: widget.youtubeVideo,
        ),
        Expanded(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final bool showChatsWindow =
                  ref.watch(isShowingChatsWindowProvide);

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kPaddingSmallConstant,
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            showDescriptionDialog(context, widget.chase);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kPaddingMediumConstant,
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
                            ChaseDetailsReactiveInformation(
                              chaseId: widget.chase.id,
                              logger: widget.logger,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class ChaseDetailsReactiveInformation extends ConsumerWidget {
  const ChaseDetailsReactiveInformation({
    Key? key,
    required this.chaseId,
    required this.logger,
  }) : super(key: key);

  final String chaseId;
  final Logger logger;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Chase> chaseDetails =
        ref.watch(streamChaseProvider(chaseId));

    return chaseDetails.when(
      data: (Chase chase) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sentiment Analysis :',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
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
                            final String shareLink =
                                await createChaseDynamicLink(
                              chase,
                              ref.read(
                                firebaseDynamicLinksProvider,
                              ),
                            );
                            await Share.share(shareLink);
                          } catch (e, stk) {
                            logger.warning(
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
                    chase: chase,
                    logger: logger,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      error: (Object error, StackTrace? stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}

class ChaseHeroSectionBuilder extends ConsumerWidget {
  const ChaseHeroSectionBuilder({
    Key? key,
    required this.chase,
    required this.imageUrl,
    required this.youtubeVideo,
  }) : super(key: key);

  final Chase chase;
  final String? imageUrl;
  final Widget youtubeVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTyping = MediaQuery.of(context).viewInsets.bottom > 0;
    final num bottomPadding =
        isTyping ? MediaQuery.of(context).size.height * 0.15 : 0;
    final num extraSizing = isTyping ? kToolbarHeight : 0;

    return AnimatedSize(
      duration: const Duration(milliseconds: 100),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * (9 / 16) -
            bottomPadding +
            extraSizing,
        width: double.maxFinite,
        child: ChaseHeroSection(
          chase: chase,
          imageURL: imageUrl,
          youtubeVideo: youtubeVideo,
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: MediaQuery.of(context).size.width * (9 / 16),
        end: MediaQuery.of(context).size.width * (9 / 16) -
            bottomPadding +
            extraSizing,
      ),
      duration: const Duration(milliseconds: 200),
      child: ChaseHeroSection(
        chase: chase,
        imageURL: imageUrl,
        youtubeVideo: youtubeVideo,
      ),
      builder: (BuildContext context, double animation, Widget? child) {
        log(animation.toString());

        return SizedBox(
          height: animation,
          width: double.maxFinite,
          child: child,
        );
      },
    );
  }
}
