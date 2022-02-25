import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_dialog.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:chaseapp/src/shared/widgets/hero_dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> notificationHandler(
    BuildContext context, NotificationData notificationData,
    {Reader? read}) async {
  switch (notificationData.getInterestEnumFromName) {
    case Interests.chasesnotifications:
      if (notificationData.data?["id"] != null)
        Navigator.pushNamed(
          context,
          RouteName.CHASE_VIEW,
          arguments: <String, dynamic>{
            "chaseId": notificationData.data!["chaseId"],
          },
        );
      break;
    case Interests.appUpdates:
      if (read != null)
        read(checkForUpdateStateNotifier.notifier).checkForUpdate(true);
      // handlebgmessage(notificationData).then<void>(
      //   (value) => read != null
      //       ? read(checkForUpdateStateNotifier.notifier).checkForUpdate(true)
      //       : null,
      // );
      break;

    default:
      Navigator.push(
        context,
        HeroDialogRoute<void>(
          builder: (context) {
            return NotificationDialog(
              notificationData: notificationData,
            );
          },
        ),
      );
  }
}
