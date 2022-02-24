import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:flutter/material.dart';

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
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.NOTIFICATIONS);
          },
          icon: Icon(
            Icons.notifications_outlined,
          ),
        )
      ],
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
