import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateNotifierBuilder.dart';
import 'package:chaseapp/src/shared/widgets/chase/chase_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ChasesPaginatedListView extends ConsumerWidget {
  const ChasesPaginatedListView({
    Key? key,
    required this.chasesPaingationProvider,
    required this.logger,
    required this.scrollController,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaingationProvider;
  final Logger logger;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        });
  }
}
