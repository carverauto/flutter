import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../../shared/widgets/draggables/chaseapp_draggable.dart';
import '../../../chase_view/view/parts/chase_details_page_internal.dart';
import '../../../chase_view/view/parts/youtube_player/youtube_player_view.dart';
import '../../../chats/view/parts/chats_view.dart';
import '../../map_view.dart';

class MapViewWrapper extends StatefulWidget {
  const MapViewWrapper({
    super.key,
  });

  @override
  State<MapViewWrapper> createState() => _MapViewWrapperState();
}

class _MapViewWrapperState extends State<MapViewWrapper> {
  bool isMapExpanded = true;
  @override
  Widget build(BuildContext context) {
    const YoutubePlayerViewWrapper player = YoutubePlayerViewWrapper(
      url: 'https://www.youtube.com/watch?v=ONJ2Cr8h6A8',
      isLive: false,
    );
    final MapBoxView map = MapBoxView(
      isInDraggableContainer: true,
      onSymbolTap: (
        String? id,
        LatLng? latLng,
      ) {},
      showAppBar: true,
      animation: const AlwaysStoppedAnimation(0),
      onExpansionButtonTap: () {},
    );

    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          final bool isPortrait = orientation == Orientation.portrait;

          return isPortrait
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          const Flexible(child: player),
                          Flexible(child: map),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 9 / 16,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      right: 0,
                      left: 0,
                      child: const SpaceXLaunchChatsWindow(),
                    ),
                  ],
                )
              : FullScreenChaseDetailsSideBar(
                  chaseDetails: const SpaceXLaunchChatsWindow(),
                  logger: Logger('SpaceMaplandscape'),
                  player: Stack(
                    children: [
                      player,
                      ChaseAppDraggableContainer(
                        onExpandTap: () {
                          setState(() {
                            isMapExpanded = !isMapExpanded;
                          });
                        },
                        child: map,
                      ),
                    ],
                  ),
                );

          //  Stack(
          //     children: [
          //       // FullScreenChaseDetailsSideBar(
          //       //   chaseDetails: const SpaceXLaunchChatsWindow(),
          //       //   logger: Logger('SpaceMaplandscape'),
          //       //   player: player,
          //       // ),
          //       ChaseAppDraggableContainer(
          //         onExpandTap: () {
          //           setState(() {
          //             isMapExpanded = !isMapExpanded;
          //           });
          //         },
          //         child: map,
          //       ),
          //     ],
          //   );
        },
      ),
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

    return SizedBox(
      height: MediaQuery.of(context).size.width * 9 / 16,
      child: Material(
        child: ChatsView(
          chaseId: '9na10xianw',
          respectBottomPadding: false,
        ),
      ),
    );
  }
}
