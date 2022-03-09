import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/connectivity_status.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/paginatedlist_bottom.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/scroll_to_top_button.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class SliversPaginatedListViewAll<T> extends ConsumerWidget {
  SliversPaginatedListViewAll({
    Key? key,
    required this.itemsPaginationProvider,
    required this.title,
    required this.logger,
    required this.builder,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final Logger logger;

  final AutoDisposeStateNotifierProvider<PaginationNotifier<T>,
      PaginationNotifierState<T>> itemsPaginationProvider;
  final String title;
  final Widget Function(
      ScrollController scrollController,
      AutoDisposeStateNotifierProvider<PaginationNotifier<T>,
              PaginationNotifierState<T>>
          itemsPaginationProvider) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton:
          ScrollToTopButton(scrollController: scrollController),
      //TODO:Update with custom refresh indicator
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onRefresh: () async {
          await ref.read(itemsPaginationProvider.notifier).fetchFirstPage(true);

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
            CustomScrollView(
              controller: scrollController,
              restorationId: title,
              slivers: [
                SliverAppBar(
                  elevation: kElevation,
                  pinned: true,
                  title: Text(title),
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
                  sliver: builder(scrollController, itemsPaginationProvider),
                ),
                SliverToBoxAdapter(
                  child: PaginatedListBottom<T>(
                      chasesPaginationProvider: itemsPaginationProvider),
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
