import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../core/notifiers/pagination_notifier.dart';
import '../../../../../models/chase/chase.dart';
import '../../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../../shared/widgets/builders/SliverPaginatedListViewAll.dart';
import '../../parts/chases_paginatedlist_view.dart';

class RecentChasesListViewAll extends ConsumerWidget {
  RecentChasesListViewAll({
    super.key,
    required this.chasesPaginationProvider,
  });

  final Logger logger = Logger('RecentChasesListView');

  final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaginationProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliversPaginatedListViewAll<Chase>(
      itemsPaginationProvider: chasesPaginationProvider,
      title: 'All Chases',
      logger: logger,
      builder: (ScrollController controller, AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>, PaginationNotifierState<Chase>> itemsProvider) {
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
