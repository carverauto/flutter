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
import 'watch_here_links.dart';

class ChaseDetails extends StatelessWidget {
  const ChaseDetails({
    Key? key,
    required this.imageURL,
    required this.logger,
    required this.chase,
    required this.chatsRow,
    required this.chatsView,
  }) : super(key: key);

  final String? imageURL;
  final Logger logger;
  final Chase chase;
  final Widget chatsRow;
  final Widget chatsView;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final bool showChatsWindow = ref.watch(isShowingChatsWindowProvide);

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
          child: showChatsWindow ? chatsView : child,
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
                      showDescriptionDialog(context, chase.id);
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
                            child: Consumer(
                              builder: (
                                BuildContext context,
                                WidgetRef ref,
                                _,
                              ) {
                                final String? title = ref.watch(
                                  streamChaseProvider(chase.id).select(
                                    (AsyncValue<Chase> value) =>
                                        value.value?.name,
                                  ),
                                );

                                return Text(
                                  title ?? 'NA',
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
                                );
                              },
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
                          RepaintBoundary(
                            child: Consumer(
                              builder: (
                                BuildContext context,
                                WidgetRef ref,
                                _,
                              ) {
                                final bool isLive = ref.watch(
                                  chaseLiveStatusChaseProvider(
                                    chase.id,
                                  ),
                                );

                                return isLive
                                    ? const GradientAnimationChildBuilder(
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
                                      )
                                    : GlassButton(
                                        child: Text(
                                          dateAdded(chase),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: kItemsSpacingSmallConstant,
                      ),
                      ChaseDetailsReactiveInformation(
                        chaseId: chase.id,
                        logger: logger,
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
              chaseId: chase.id,
            ),
            Divider(
              height: kItemsSpacingSmall,
            ),
            chatsRow,
          ],
        ),
      ),
    );
  }
}
