import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_types_list.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notifications_list.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsView extends StatelessWidget {
  NotificationsView({Key? key}) : super(key: key);

  final Logger logger = Logger('NotificationsView');

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = notificationsStreamProvider(logger);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          ProviderStateBuilder<List<String?>>(
            watchThisProvider: usersInterestsStreamProvider,
            logger: logger,
            builder: (userInterests, ref) {
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
