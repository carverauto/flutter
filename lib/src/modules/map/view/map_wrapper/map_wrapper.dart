import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../chats/view/parts/chats_view.dart';

class MapViewWrapper extends StatelessWidget {
  const MapViewWrapper({
    super.key,
    required this.mapView,
    required this.chatView,
  });

  final Widget mapView;
  final Widget chatView;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapView,
        chatView,
      ],
    );
  }
}

class SpaceXLaunchChatsWindow extends StatelessWidget {
  const SpaceXLaunchChatsWindow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).viewInsets.bottom.toString());

    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      right: 0,
      left: 0,
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 9 / 16,
        child: Material(
          child: ChatsView(
            chaseId: '9na10xianw',
            respectBottomPadding: false,
          ),
        ),
      ),
    );
  }
}
