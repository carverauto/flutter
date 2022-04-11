import 'package:flutter/material.dart';

import '../../../../const/images.dart';
import '../../../notifications/view/parts/notifications_appbar_button.dart';

class ChaseAppBar extends StatelessWidget {
  const ChaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      centerTitle: true,
      // backgroundColor: Colors.transparent,
      title: ChaseAppLogoImage(),
      floating: true,
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
