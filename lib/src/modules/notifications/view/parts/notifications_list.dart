import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../const/sizings.dart';
import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../dashboard/view/parts/paginatedlist_bottom.dart';
import '../../../dashboard/view/parts/scroll_to_top_button.dart';
import 'notifications_list_builder.dart';

class NotificationsViewAll extends ConsumerWidget {
  NotificationsViewAll({
    Key? key,
    required this.chasesPaginationProvider,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final Logger logger = Logger('RecentChasesListView');

  final AutoDisposeStateNotifierProvider<
      PaginationNotifier<ChaseAppNotification>,
      PaginationNotifierState<ChaseAppNotification>> chasesPaginationProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton:
          ScrollToTopButton(scrollController: scrollController),
      //TODO:Update with custom refresh indicator
      body: CustomScrollView(
        controller: scrollController,
        restorationId: 'All Notifications',
        slivers: [
          // Error if removed (Need to report)
          const SliverToBoxAdapter(
            child: SizedBox(
              height: kPaddingMediumConstant,
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
            sliver: NotificationsPaginatedListView(
              chasesPaginationProvider: chasesPaginationProvider,
              logger: logger,
              scrollController: scrollController,
              axis: Axis.vertical,
            ),
          ),
          SliverToBoxAdapter(
            child: PaginatedListBottom<ChaseAppNotification>(
              chasesPaginationProvider: chasesPaginationProvider,
            ),
          ),
        ],
      ),
    );
  }
}
