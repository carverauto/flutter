import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsPaginatedListView extends ConsumerWidget {
  NotificationsPaginatedListView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
    required this.scrollController,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<NotificationData>,
      PaginationNotifierState<NotificationData>> chasesPaginationProvider;
  final Logger logger;
  final ScrollController scrollController;

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverProviderPaginatedStateNotifierBuilder<NotificationData>(
        watchThisStateNotifierProvider: chasesPaginationProvider,
        logger: logger,
        scrollController: scrollController,
        axis: axis,
        builder: (notifications, controller, [Widget? bottomWidget]) {
          return notifications.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none_outlined,
                      ),
                      Chip(
                        label: Text("No Notifications!"),
                      ),
                    ],
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            notifications[index].image ?? defaultPhotoURL,
                          ),
                        ),
                        title: Text(notifications[index].title ?? "NA",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            )),
                        subtitle: Text(notifications[index].body ?? "NA",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            )),
                      );
                    },
                    childCount: notifications.length,
                  ),
                );
        });
  }
}
