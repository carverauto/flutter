import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../const/colors.dart';
import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../../../../shared/util/helpers/date_added.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../signin/view/parts/gradient_animation_container.dart';
import '../providers/providers.dart';
import 'chase_description_dialog.dart';
import 'chase_details_reactive_info.dart';
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
                                  Consumer(
                                    builder: (
                                      BuildContext context,
                                      WidgetRef ref,
                                      _,
                                    ) {
                                      return const RepaintBoundary(
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
                                      );
                                    },
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
