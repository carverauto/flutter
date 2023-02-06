import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../const/colors.dart';
import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../../shared/util/helpers/date_added.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../app_review/app_review_notifier.dart';
import '../../../signin/view/parts/gradient_animation_container.dart';
import '../providers/providers.dart';
import 'chase_description_dialog.dart';
import 'chase_details_reactive_info.dart';
import 'networks_content/watch_here_links.dart';

class ChaseDetails extends ConsumerWidget {
  const ChaseDetails({
    super.key,
    required this.imageURL,
    required this.logger,
    required this.chase,
    required this.chatsRow,
    required this.chatsView,
  });

  final String? imageURL;
  final Logger logger;
  final Chase chase;
  final Widget chatsRow;
  final Widget chatsView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Material(
                  child: Column(
                    children: [
                      ChaseAppPremiumChaseViewHeader(
                        action: 'Go Premium',
                        label: 'Explore more with ChaseApp Premium',
                        onHide: () {
                          ref
                              .read(appReviewStateNotifier.notifier)
                              .hideChaseViewPremiumHeader();
                        },
                        showHeader: () {
                          return ref
                              .read(appReviewStateNotifier.notifier)
                              .shouldShowPremiumHeader;
                        },
                      ),
                      const SizedBox(
                        height: kPaddingSmallConstant,
                      ),
                      InkWell(
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
                                          .titleLarge!
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
                    ],
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

class ChaseAppPremiumChaseViewHeader extends ConsumerStatefulWidget {
  const ChaseAppPremiumChaseViewHeader({
    super.key,
    required this.label,
    required this.onHide,
    required this.showHeader,
    this.axis = Axis.horizontal,
    required this.action,
  });

  final String label;
  final VoidCallback onHide;
  final bool Function() showHeader;
  final Axis axis;
  final String action;

  @override
  ConsumerState<ChaseAppPremiumChaseViewHeader> createState() =>
      _ChaseAppPremiumChaseViewHeaderState();
}

class _ChaseAppPremiumChaseViewHeaderState
    extends ConsumerState<ChaseAppPremiumChaseViewHeader> {
  @override
  Widget build(BuildContext context) {
    final bool showHeader = widget.showHeader();

    if (!showHeader) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        const Positioned.fill(
          child: AnimatingGradientShaderBuilder(
            child: ColoredBox(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingMediumConstant,
          ),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  widget.label,
                  textAlign:
                      widget.axis == Axis.vertical ? TextAlign.center : null,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: kPaddingSmallConstant,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteName.IN_APP_PURCHASES);
                },
                child: Text(
                  widget.action,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: kPaddingSmallConstant,
              ),
              OutlinedButton(
                onPressed: () {
                  widget.onHide();

                  setState(() {});
                },
                child: const Text(
                  'Hide',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
