import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
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

class Dashboard extends ConsumerWidget {
  Dashboard({Key? key}) : super(key: key);

  // final ScrollController scrollController = ScrollController();
  final Logger logger = Logger('Dashboard');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chasesPaginationProvider = chasesPaginatedStreamProvider(logger);

    return Scaffold(
      drawer: ChaseAppDrawer(),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        edgeOffset: kItemsSpacingLargeConstant,
        onRefresh: () async {
          await ref
              .read(chasesPaginationProvider.notifier)
              .fetchFirstPage(true);
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
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
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
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
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
          ],
        ),
      ),
    );
  }
}
