import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/chases/view/parts/chases_paginatedlist_view.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverPaginatedListViewAll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class RecentChasesListViewAll extends ConsumerWidget {
  RecentChasesListViewAll({
    Key? key,
    required this.chasesPaginationProvider,
  }) : super(key: key);

  final Logger logger = Logger('RecentChasesListView');

  final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaginationProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliversPaginatedListViewAll<Chase>(
      itemsPaginationProvider: chasesPaginationProvider,
      title: "All Chases",
      logger: logger,
      builder: (controller, itemsProvider) {
        return ChasesPaginatedListView(
          chasesPaginationProvider: chasesPaginationProvider,
          logger: logger,
          scrollController: controller,
          axis: Axis.vertical,
        );
      },
    );
  }
}
