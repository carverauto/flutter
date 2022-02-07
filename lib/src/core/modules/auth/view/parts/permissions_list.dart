import 'package:chaseapp/src/const/info.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permissions_row.dart';
import 'package:flutter/material.dart';

class PermissionsList extends StatelessWidget {
  const PermissionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PermissionRow(
          icon: Icons.location_pin,
          title: "Location",
          subTitle: "Location permissions for location tracking.",
          info: locationUsageInfo,
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        PermissionRow(
          icon: Icons.bluetooth_connected,
          title: "Bluetooth",
          subTitle: "Bluetooth permissions for bluetooth activities.",
          info: bluetoothUsageInfo,
        ),
        Divider(),
        PermissionRow(
          icon: Icons.notifications_active,
          title: "Notifications",
          subTitle: "Notifications permission for recieving notifications.",
          info: notificationsUsageInfo,
        ),
        Divider(),
      ],
    );
  }
}
