import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/chases_paginatedlist_view.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/connectivity_status.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/dropdown_button.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/paginatedlist_bottom.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/scroll_to_top_button.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class Dashboard extends ConsumerWidget {
  Dashboard({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final Logger logger = Logger('Dashboard');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chasesPaingationProvider = chasesPaginatedStreamProvider(logger);
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(chasesPaingationProvider.notifier).fetchNextPage();
      }
    });
    return Scaffold(
      floatingActionButton:
          ScrollToTopButton(scrollController: scrollController),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onRefresh: () async {
          ref.read(chasesPaingationProvider.notifier).fetchFirstPage(true);
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              restorationId: "Chases List",
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  elevation: kElevation,
                  pinned: true,
                  title: Image.asset(
                    chaseAppNameImage,
                    height: kImageSizeLarge,
                  ),
                  actions: [
                    ChaseAppDropDownButton(
                      child: CircleAvatar(
                        radius: kImageSizeSmall,
                        backgroundImage: CachedNetworkImageProvider(
                          ref.watch(userStreamProvider.select(
                                  (value) => value.asData?.value.photoURL)) ??
                              defaultPhotoURL,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kItemsSpacingSmallConstant,
                    ),
                  ],
                ),

                // Error if removed (Need to report)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: kPaddingMediumConstant,
                  ),
                ),
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
                  sliver: ChasesPaginatedListView(
                      chasesPaingationProvider: chasesPaingationProvider,
                      logger: logger,
                      scrollController: scrollController),
                ),
                SliverToBoxAdapter(
                  child: PaginatedListBottom(
                      chasesPaingationProvider: chasesPaingationProvider),
                ),
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
