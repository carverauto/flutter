import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:riverpod/src/common.dart';
import 'package:riverpod/src/state_notifier_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../const/sizings.dart';
import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../parts/notification_settings.dart';
import '../parts/notification_types_list.dart';
import '../parts/notifications_list.dart';
import '../providers/providers.dart';

class NotificationsView extends StatelessWidget {
  NotificationsView({Key? key}) : super(key: key);

  final Logger logger = Logger('NotificationsView');

  @override
  Widget build(BuildContext context) {
    final AutoDisposeStateNotifierProvider<
            PaginationNotifier<ChaseAppNotification>,
            PaginationNotifierState<ChaseAppNotification>>
        notificationsProvider = notificationsStreamProvider(logger);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const NotificationsSettings(),
                ),
              );
            },
            icon: const Icon(Icons.edit_notifications),
          )
        ],
      ),
      body: Column(
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final AsyncValue<NotificationPermissionStatuses> state =
                  ref.watch(userNotificationAcceptanceFutureProvider);

              return state.maybeWhen(
                orElse: () {
                  return const SizedBox.shrink();
                },
                data: (NotificationPermissionStatuses value) {
                  if ((value.userPermissionDialogAcceptance != null &&
                          !value.userPermissionDialogAcceptance!) ||
                      value.permissionFromDevice) {
                    return const SizedBox.shrink();
                  }

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(kPaddingSmallConstant),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Enable push notifications to know when a new chase happens.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: kItemsSpacingMediumConstant,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const NotificationsSettings(),
                                ),
                              );
                            },
                            child: const Text('Enable'),
                          ),
                          const SizedBox(
                            height: kItemsSpacingMediumConstant,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          ProviderStateBuilder<List<String?>>(
            watchThisProvider: usersInterestsStreamProvider,
            logger: logger,
            builder:
                (List<String?> userInterests, WidgetRef ref, Widget? child) {
              return NotificationTypes(
                userInterests: userInterests,
              );
            },
          ),
          Expanded(
            child: NotificationsViewAll(
              chasesPaginationProvider: notificationsProvider,
            ),
          )
        ],
      ),
    );
  }
}
