import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationSettingTile extends StatelessWidget {
  const NotificationSettingTile({
    Key? key,
    required this.interest,
    required this.isUsersInterest,
  }) : super(key: key);

  final Interest interest;
  final bool isUsersInterest;

  @override
  Widget build(BuildContext context) {
    final displayName = toBeginningOfSentenceCase(interest.name.split("-")[0])!;

    return ListTile(
      title: Text(
        displayName,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: NotificationSettingTileSwitch(
        interest: interest,
        isUsersInterest: isUsersInterest,
      ),
    );
  }
}

class NotificationSettingTileSwitch extends ConsumerStatefulWidget {
  const NotificationSettingTileSwitch({
    Key? key,
    required this.interest,
    required this.isUsersInterest,
  }) : super(key: key);

  final Interest interest;
  final bool isUsersInterest;

  @override
  ConsumerState<NotificationSettingTileSwitch> createState() =>
      _NotificationSettingTileSwitchState();
}

class _NotificationSettingTileSwitchState
    extends ConsumerState<NotificationSettingTileSwitch> {
  late bool isEnabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEnabled = widget.interest.isCompulsory || widget.isUsersInterest;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
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
    );
  }
}
