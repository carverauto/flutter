import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/paginatedlist_bottom.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/scroll_to_top_button.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notifications_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class NotificationsViewAll extends ConsumerWidget {
  NotificationsViewAll({
    Key? key,
    required this.chasesPaginationProvider,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final Logger logger = Logger('RecentChasesListView');

  final StateNotifierProvider<PaginationNotifier<NotificationData>,
      PaginationNotifierState<NotificationData>> chasesPaginationProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton:
          ScrollToTopButton(scrollController: scrollController),
      //TODO:Update with custom refresh indicator
      body: CustomScrollView(
        controller: scrollController,
        restorationId: "All Notifications",
        slivers: [
          // Error if removed (Need to report)
          SliverToBoxAdapter(
            child: SizedBox(
              height: kPaddingMediumConstant,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
            sliver: NotificationsPaginatedListView(
              chasesPaginationProvider: chasesPaginationProvider,
              logger: logger,
              scrollController: scrollController,
              axis: Axis.vertical,
            ),
          ),
          SliverToBoxAdapter(
            child: PaginatedListBottom<NotificationData>(
                chasesPaginationProvider: chasesPaginationProvider),
          ),
        ],
      ),
    );
  }
}
