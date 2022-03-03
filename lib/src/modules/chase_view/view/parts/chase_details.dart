import 'dart:developer';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_description_dialog.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/donut_clap_button.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/watch_here_video.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/modules/chats/view/pages/chats_row_view.dart';
import 'package:chaseapp/src/modules/chats/view/parts/chats_view.dart';
import 'package:chaseapp/src/modules/signin/view/parts/gradient_animation_container.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/dynamiclink_generator.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:chaseapp/src/shared/widgets/sentiment_analysis_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

class ChaseDetails extends ConsumerStatefulWidget {
  ChaseDetails({
    Key? key,
    required this.imageURL,
    required this.logger,
    required this.chase,
    required this.youtubeVideo,
    required this.onYoutubeNetworkTap,
  }) : super(key: key);

  final String? imageURL;
  final Logger logger;
  final Chase chase;
  final Widget youtubeVideo;
  final void Function(String url) onYoutubeNetworkTap;

  @override
  ConsumerState<ChaseDetails> createState() => _ChaseDetailsState();
}

class _ChaseDetailsState extends ConsumerState<ChaseDetails> {
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   if (chaseDetailsKey.currentContext != null) {
    //     final renderbox =
    //         chaseDetailsKey.currentContext!.findRenderObject() as RenderBox;
    //     final height = renderbox.size.height;
    //     final finalHeight = ref.read(chaseDetailsHeightProvider);
    //     if (finalHeight == null) {
    //       ref.read(chaseDetailsHeightProvider.state).update((state) => height);
    //     }
    //   }
    // });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(builder: (context) {
          final bottomPadding = MediaQuery.of(context).viewInsets.bottom > 0
              ? MediaQuery.of(context).size.height * 0.1
              : 0;
          log('bottomPadding: $bottomPadding');
          return AnimatedContainer(
            height:
                MediaQuery.of(context).size.width * (9 / 16) - bottomPadding,
            width: double.maxFinite,
            duration: Duration(milliseconds: 500),
            child: Container(
              color: Colors.blue,
            ),
          );
        }),

        // Consumer(builder: ((context, ref, child) {
        //   final showChatsWindow = ref.watch(showChatsWindowProvider);
        //   final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
        //   log(bottomPadding.toString());
        //   return AnimatedContainer(
        //     // aspectRatio:  16 / 9,
        //     // scale: showChatsWindow ? 0.8 : 1,
        //     height:
        //         MediaQuery.of(context).size.width * (9 / 16) - bottomPadding,
        //     width: double.maxFinite,
        //     duration: Duration(milliseconds: 500),
        //     child: AspectRatio(
        //       aspectRatio: 16 / 9,
        //       child: Container(
        //         color: Colors.blue,
        //       ),
        //     ),
        //   );
        // })),
        // ChaseHeroSection(
        //   chase: widget.chase,
        //   imageURL: widget.imageURL,
        //   youtubeVideo: widget.youtubeVideo,
        // ),
        Expanded(
          // key: chaseDetailsKey,
          child: Stack(
            children: [
              ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  padding: EdgeInsets.all(0),
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
                                  widget.chase.name ?? "NA",
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
                              if (widget.chase.live ?? false)
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
                          SizedBox(
                            height: kItemsSpacingSmallConstant,
                          ),
                          Text(
                            "Sentiment Analysis :",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                          ),
                          SizedBox(
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
                                          final shareLink =
                                              await createChaseDynamicLink(
                                                  widget.chase);
                                          Share.share(shareLink);
                                        } catch (e, stk) {
                                          widget.logger.warning(
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
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    WatchHereLinksWrapper(
                      chase: widget.chase,
                      onYoutubeNetworkTap: widget.onYoutubeNetworkTap,
                    ),
                    Divider(
                      height: kItemsSpacingSmall,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    ChatsViewRow(chase: widget.chase)
                  ],
                ),
              ),
              Consumer(
                child: ChatsView(
                  chase: widget.chase,
                ),
                builder: ((context, ref, child) {
                  final showChatsWindow = ref.watch(showChatsWindowProvider);
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 1),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: showChatsWindow ? child : SizedBox.shrink(),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
