import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_setting_tile.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsSettings extends StatelessWidget {
  NotificationsSettings({Key? key}) : super(key: key);

  final Logger logger = Logger("NotificationsSettings");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Settings"),
        elevation: 0,
      ),
      body: ProviderStateBuilder<List<Interest>>(
          builder: (interests, ref) {
            return ProviderStateBuilder<List<String?>>(
                builder: (usersInterests, ref) {
                  return ListView.builder(
                    itemCount: interests.length,
                    itemBuilder: (context, index) {
                      final interest = interests[index];
                      final isUsersInterest =
                          usersInterests.contains(interest.name);
                      return NotificationSettingTile(
                          interest: interest, isUsersInterest: isUsersInterest);
                    },
                  );
                },
                watchThisProvider: usersInterestsStreamProvider,
                logger: logger);
          },
          watchThisProvider: interestsProvider,
          logger: logger),
    );
  }
}
