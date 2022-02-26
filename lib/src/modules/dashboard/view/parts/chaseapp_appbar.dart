import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaseAppBar extends StatelessWidget {
  const ChaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: ChaseAppLogoImage(),
      actions: [
        NotificationsAppbarButton(),
      ],
    );
  }
}

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
            if (newNotificationsPresent)
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

class ChaseAppLogoImage extends StatelessWidget {
  const ChaseAppLogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      chaseAppNameImage,
      color: Colors.white,
      cacheHeight: 60,
      cacheWidth: 478,
    );
  }
}
