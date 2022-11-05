import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../const/colors.dart';
import '../../../../const/sizings.dart';
import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/notifications/notification_tile.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../bof/bof_view.dart';
import '../../../chases/view/pages/recent_chases/recent_chases.dart';
import '../../../chases/view/pages/top_chases/top_chases.dart';
import '../../../chases/view/providers/providers.dart';
import '../../../firehose/view/pages/firehose_view_all.dart';
import '../parts/chaseapp_appbar.dart';
import '../parts/chaseapp_drawer.dart';
import '../parts/connectivity_status.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  // final ScrollController scrollController = ScrollController();
  final Logger logger = Logger('Dashboard');

  @override
  Widget build(BuildContext context) {
    final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
            PaginationNotifierState<Chase>> chasesPaginationProvider =
        chasesPaginatedStreamProvider(logger);

    return Scaffold(
      drawer: const ChaseAppDrawer(),
      body: _DashboardMainView(
        chasesPaginationProvider: chasesPaginationProvider,
        logger: logger,
      ),
    );
  }
}

class _DashboardMainView extends ConsumerStatefulWidget {
  const _DashboardMainView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaginationProvider;
  final Logger logger;

  @override
  ConsumerState<_DashboardMainView> createState() => _DashboardMainViewState();
}

class _DashboardMainViewState extends ConsumerState<_DashboardMainView> {
  final ScrollController controller = ScrollController();

  bool isMapExpanded = false;

  void onMapExpansion(bool value) {
    if (value != isMapExpanded) {
      setState(() {
        isMapExpanded = value;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      edgeOffset: kItemsSpacingLargeConstant,
      onRefresh: () async {
        await ref
            .read(widget.chasesPaginationProvider.notifier)
            .fetchFirstPage(true);
        ref.refresh(topChasesStreamProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassButton(
                  padding: const EdgeInsets.all(
                    kPaddingSmallConstant,
                  ),
                  child: Text(
                    'Refreshed',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.all(30),
          ),
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: DashboardBGPainter(),
                size: MediaQuery.of(context).size,
              ),
            ),
          ),
          CustomScrollView(
            physics: isMapExpanded
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            restorationId: 'Chases List',
            controller: controller,
            slivers: [
              // AppBar
              ChaseAppBar(
                onMapExpansion: onMapExpansion,
              ),

              // Error if removed (Need to report)
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kPaddingSmallConstant,
                ),
              ),
              const SliverToBoxAdapter(
                child: BofView(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kPaddingSmallConstant,
                ),
              ),

              //Top Chases
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingMediumConstant,
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingMediumConstant,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const NotificationTrailingIcon(
                        notificationType: 'chase',
                      ),
                      const SizedBox(
                        width: kPaddingXSmallConstant,
                      ),
                      Text(
                        'Top Chases',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingSmallConstant,
                ),
              ),

              TopChasesListView(
                logger: widget.logger,
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingMediumConstant,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingMediumConstant,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        '🔥 Firehose',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.FIREHOSE_VIEW_ALL,
                          );
                        },
                        icon: Text(
                          'View All',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        label: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingSmallConstant,
                ),
              ),
              const FirehoseListViewAll(
                showLimited: true,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingSmallConstant,
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingMediumConstant,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const NotificationTrailingIcon(notificationType: 'chase'),
                      const SizedBox(
                        width: kPaddingXSmallConstant,
                      ),
                      Text(
                        'Recent',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.RECENT_CHASESS_VIEW_ALL,
                            arguments: {
                              'chasesPaginationProvider':
                                  widget.chasesPaginationProvider,
                            },
                          );
                        },
                        icon: Text(
                          'See More',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        label: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingSmallConstant,
                ),
              ),

              RecentChasesList(
                chasesPaginationProvider: widget.chasesPaginationProvider,
                logger: widget.logger,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: kItemsSpacingLargeConstant * 3,
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top +
                kToolbarHeight +
                kItemsSpacingSmallConstant,
            width: MediaQuery.of(context).size.width,
            child: const ConnectivityStatus(),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: isMapExpanded
                      ? const SizedBox.shrink()
                      : CustomPaint(
                          painter: OverlayCustomPainter(),
                          size: MediaQuery.of(context).size,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlayCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color.fromARGB(255, 26, 25, 25),
          Colors.transparent,
        ],
        stops: [
          0.0,
          0.2,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPaint(paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class DashboardBGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.shade700,
          primaryColor.shade900.withOpacity(0.4),
        ],
        stops: const [
          0.0,
          0.8,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPaint(paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
