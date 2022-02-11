import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class ChaseAppBar extends StatelessWidget {
  const ChaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Image.asset(
        chaseAppNameImage,
        height: kImageSizeLarge,
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () {
            throw UnimplementedError();
          },
          icon: Icon(
            Icons.notifications_outlined,
          ),
        )
      ],
    );
  }
}
