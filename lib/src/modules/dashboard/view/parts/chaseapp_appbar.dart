import 'package:flutter/material.dart';

import '../../../../const/images.dart';
import '../../../map/map_view.dart';
import '../../../notifications/view/parts/notifications_appbar_button.dart';

class ChaseAppBar extends StatelessWidget {
  const ChaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = width / (16 / 9);

    return SliverAppBar(
      centerTitle: true,
      // backgroundColor: Colors.transparent,
      title: const ChaseAppLogoImage(),
      floating: true,
      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
        background: AspectRatio(
          aspectRatio: 16 / 9,
          // GEstureDetector won't work?
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: 'Go Full View',
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const MapBoxView(
                        showAppBar: true,
                      );
                    },
                  ),
                );
              },
              child: const Icon(
                Icons.open_with,
              ),
            ),
            body: const MapBoxView(),
          ),
        ),
      ),
      actions: const [
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
