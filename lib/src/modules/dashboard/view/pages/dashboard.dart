import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/connectivity_status.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/recent_chases/recent_chases.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/top_chases/top_chases.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
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
    final chasesPaingationProvider = chasesPaginatedStreamProvider(logger);
    // scrollController.addListener(() {
    //   double maxScroll = scrollController.position.maxScrollExtent;
    //   double currentScroll = scrollController.position.pixels;
    //   double delta = MediaQuery.of(context).size.width * 0.20;
    //   if (maxScroll - currentScroll <= delta) {
    //     ref.read(chasesPaingationProvider.notifier).fetchNextPage();
    //   }
    // });
    return Scaffold(
      // floatingActionButton:
      //     ScrollToTopButton(scrollController: scrollController),
      drawer: Drawer(),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        edgeOffset: kItemsSpacingLargeConstant,
        onRefresh: () async {
          await ref
              .read(chasesPaingationProvider.notifier)
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
                    child: Text("Refreshed"),
                  ),
                ],
              ),
              margin: EdgeInsets.all(30),
            ),
          );
        },
        child: Stack(
          children: [
            CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              // controller: scrollController,
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
                ChasesMap(),
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
                            //TODO: Implement navigation to see more
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
                  chasesPaingationProvider: chasesPaingationProvider,
                  logger: logger,
                ),
                // SliverToBoxAdapter(
                //   child: PaginatedListBottom(
                //       chasesPaingationProvider: chasesPaingationProvider),
                // ),
              ],
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

class ChasesMap extends StatelessWidget {
  const ChasesMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Placeholder(
        fallbackHeight: 150,
      ),
    );
  }
}

class ChaseAppBar extends StatelessWidget {
  const ChaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(colors: [
            Colors.red,
            Colors.blue,
          ], stops: [
            0.1,
            0.6,
          ]).createShader(rect);
        },
        child: Image.asset(
          chaseAppNameImage,
          height: kImageSizeLarge,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            throw UnimplementedError();
          },
          icon: Icon(
            Icons.notifications_outlined,
          ),
        )
      ],
    );
  }
}
