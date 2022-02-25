import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class NotificationSettingTile extends ConsumerStatefulWidget {
  const NotificationSettingTile({
    Key? key,
    required this.interest,
    required this.isUsersInterest,
  }) : super(key: key);

  final Interest interest;
  final bool isUsersInterest;

  @override
  ConsumerState<NotificationSettingTile> createState() =>
      _NotificationSettingTileState();
}

class _NotificationSettingTileState
    extends ConsumerState<NotificationSettingTile> {
  late bool isEnabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnabled = widget.interest.isCompulsory || widget.isUsersInterest;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.local_police,
        color: Theme.of(context).primaryColorLight,
      ),
      title: Text(
        widget.interest.name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: Switch(
        value: isEnabled,
        onChanged: widget.interest.isCompulsory
            ? null
            : (value) async {
                if (value) {
                  await ref
                      .read(pusherBeamsProvider)
                      .addDeviceInterest(widget.interest.name);
                } else {
                  await ref
                      .read(pusherBeamsProvider)
                      .removeDeviceInterest(widget.interest.name);
                }
                setState(() {
                  isEnabled = value;
                });
              },
      ),
    );
  }
}
