import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/chaseapp_appbar.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/chaseapp_drawer.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/connectivity_status.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/recent_chases/recent_chases.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/top_chases/top_chases.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/modules/firehose/view/pages/firehose.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  // final ScrollController scrollController = ScrollController();
  final Logger logger = Logger('Dashboard');

  @override
  Widget build(BuildContext context) {
    final chasesPaginationProvider = chasesPaginatedStreamProvider(logger);

    return Scaffold(
        drawer: ChaseAppDrawer(),
        body: _DashboardMainView(
            chasesPaginationProvider: chasesPaginationProvider, logger: logger)

        //  ProviderStateBuilder(
        //     errorBuilder: (context, stk) => DashboardMainView(
        //         chasesPaginationProvider: chasesPaginationProvider,
        //         logger: logger),
        //     builder: (data, ref, child) => DashboardMainView(
        //         chasesPaginationProvider: chasesPaginationProvider,
        //         logger: logger),
        //     watchThisProvider: topChasesStreamProvider,
        //     logger: logger),
        );
  }
}

class _DashboardMainView extends ConsumerWidget {
  const _DashboardMainView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaginationProvider;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      edgeOffset: kItemsSpacingLargeConstant,
      onRefresh: () async {
        await ref.read(chasesPaginationProvider.notifier).fetchFirstPage(true);
        await ref.refresh(topChasesStreamProvider);

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
                  padding: EdgeInsets.all(
                    kPaddingSmallConstant,
                  ),
                  child: Text(
                    "Refreshed",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.all(30),
          ),
        );
      },
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.shade700,
                    primaryColor.shade900.withOpacity(0.4),
                  ],
                  stops: [
                    0.0,
                    0.8,
                  ]),
            ),
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              restorationId: "Chases List",
              slivers: [
                // AppBar
                ChaseAppBar(),

                // Error if removed (Need to report)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kPaddingMediumConstant,
                  ),
                ),
                // Chases Map
                // ChasesMap(),
                // For Clusters
                //  SliverToBoxAdapter(
                //   child: SizedBox(
                //     height: kPaddingMediumConstant,
                //   ),
                // ),

                //Top Chases
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingMediumConstant,
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingMediumConstant),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Top Chases",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingSmallConstant,
                  ),
                ),

                TopChasesListView(
                  logger: logger,
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingMediumConstant,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingMediumConstant),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          "Firehose",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.FIREHOSE_VIEW_ALL,
                            );
                          },
                          icon: Text(
                            "View All",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                          ),
                          label: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingSmallConstant,
                  ),
                ),
                FireHoseView(),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingSmallConstant,
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingMediumConstant),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          "Recent",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.RECENT_CHASESS_VIEW_ALL,
                              arguments: {
                                "chasesPaginationProvider":
                                    chasesPaginationProvider,
                              },
                            );
                          },
                          icon: Text(
                            "See More",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                          ),
                          label: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingSmallConstant,
                  ),
                ),

                RecentChasesList(
                  chasesPaginationProvider: chasesPaginationProvider,
                  logger: logger,
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kItemsSpacingLargeConstant * 3,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top +
                kToolbarHeight +
                kItemsSpacingSmallConstant,
            width: MediaQuery.of(context).size.width,
            child: ConnectivityStatus(),
          ),
          Positioned.fill(
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(255, 26, 25, 25),
                          Colors.transparent,
                        ],
                        stops: [
                          0.0,
                          0.2,
                        ]),
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
