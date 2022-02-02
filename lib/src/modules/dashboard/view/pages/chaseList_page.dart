import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/dropdown_button.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateNotifierBuilder.dart';
import 'package:chaseapp/src/shared/widgets/chase/chase_tile.dart';
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
      floatingActionButton: AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          double scrollOffset = scrollController.offset;
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: scrollOffset > Sizescaleconfig.screenheight! * 0.5
                ? FloatingActionButton(
                    tooltip: "Scroll to top",
                    child: Icon(
                      Icons.arrow_upward,
                    ),
                    onPressed: () async {
                      scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                : SizedBox.shrink(),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(chasesPaingationProvider.notifier).fetchFirstPage(true);
        },
        child: CustomScrollView(
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
              padding: EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
              sliver: ProviderStateNotifierBuilder<List<Chase>>(
                  watchThisStateNotifierProvider: chasesPaingationProvider,
                  logger: logger,
                  scrollController: scrollController,
                  builder: (chases, controller, [Widget? bottomWidget]) {
                    return chases.isEmpty
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(chasesPaginatedStreamProvider(
                                                logger)
                                            .notifier)
                                        .fetchFirstPage(true);
                                  },
                                  icon: Icon(Icons.replay),
                                ),
                                Chip(
                                  label: Text("No Chases Found!"),
                                ),
                              ],
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final chase = chases[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: kPaddingMediumConstant,
                                  ),
                                  child: ChaseTile(chase: chase),
                                );
                              },
                              childCount: chases.length,
                            ),
                          );
                  }),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.center,
                child: Consumer(
                  builder: (context, ref, _) {
                    return ref.watch(chasesPaingationProvider).maybeWhen(
                          data: (chases, canLoad) {
                            final isFetching = ref
                                .read(chasesPaingationProvider.notifier)
                                .isFetching;
                            final onGoingState = ref
                                .read(chasesPaingationProvider.notifier)
                                .onGoingState;
                            return BottomWidget(
                              isFetching: isFetching,
                              onGoingState: onGoingState,
                              watchThisStateNotifierProvider:
                                  chasesPaingationProvider,
                            );
                          },
                          orElse: () => SizedBox.shrink(),
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
