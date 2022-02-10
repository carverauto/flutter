import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/paginatedlist_bottom.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/top_chases/top_chase_builder.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ChasesPaginatedListView extends ConsumerWidget {
  ChasesPaginatedListView({
    Key? key,
    required this.chasesPaingationProvider,
    required this.logger,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaingationProvider;
  final Logger logger;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(chasesPaingationProvider.notifier).fetchNextPage();
      }
    });
    return ProviderStateNotifierBuilder<List<Chase>>(
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
                              .read(chasesPaginatedStreamProvider(logger)
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
              : SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: GridView.count(
                      controller: scrollController,
                      crossAxisCount: 1,
                      childAspectRatio: 1.2,
                      mainAxisSpacing: kItemsSpacingSmallConstant,
                      padding: EdgeInsets.symmetric(
                          horizontal: kItemsSpacingMediumConstant),
                      scrollDirection: Axis.horizontal,
                      crossAxisSpacing: kItemsSpacingSmallConstant,
                      children: chases.map((chase) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: kPaddingMediumConstant,
                          ),
                          child: TopChaseBuilder(
                            chase: chase,
                          ),
                        );
                      }).toList()
                        ..add(
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PaginatedListBottom(
                              chasesPaingationProvider:
                                  chasesPaingationProvider,
                            ),
                          ),
                        ),
                    ),
                  ),
                );

          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       final chase = chases[index];

          //       return Padding(
          //         padding: const EdgeInsets.only(
          //           bottom: kPaddingMediumConstant,
          //         ),
          //         child: ChaseTile(chase: chase),
          //       );
          //     },
          //     childCount: chases.length,
          //   ),
          // );
        });
  }
}
