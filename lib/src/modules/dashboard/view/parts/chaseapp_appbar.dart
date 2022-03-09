import 'package:chaseapp/src/const/images.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notifications_appbar_button.dart';
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
        NotificationsAppbarButton(),
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
