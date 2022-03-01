import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsAppbarButton extends ConsumerWidget {
  const NotificationsAppbarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newNotificationsPresent = ref
            .read(sharedPreferancesProvider)
            .getBool("newNotificationsPresent") ??
        false;

    final notificationsPresent = ref.watch(newNotificationsPresentProvider);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.NOTIFICATIONS);
      },
      child: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.NOTIFICATIONS);
        },
        icon: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
            ),
            if (notificationsPresent)
              Positioned(
                right: 2,
                top: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
