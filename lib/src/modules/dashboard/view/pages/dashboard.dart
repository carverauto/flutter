import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/chases_paginatedlist_view.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/connectivity_status.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/top_chases/top_chases.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
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
        onRefresh: () async {
          ref.read(chasesPaingationProvider.notifier).fetchFirstPage(true);
        },
        child: Stack(
          children: [
            CustomScrollView(
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

                TopChasesListView(
                  logger: logger,
                ),

                ChasesPaginatedListView(
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
