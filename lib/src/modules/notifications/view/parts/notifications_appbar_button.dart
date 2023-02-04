import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/routeNames.dart';
import '../providers/providers.dart';

class NotificationsAppbarButton extends ConsumerWidget {
  const NotificationsAppbarButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool notificationsPresent = ref.watch(newNotificationsPresentProvider);
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
            const Icon(
              Icons.notifications_outlined,
            ),
            if (notificationsPresent)
              Positioned(
                right: 2,
                top: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
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
