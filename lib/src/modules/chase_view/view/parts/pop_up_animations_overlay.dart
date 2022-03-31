import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../models/chase/chase.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../providers/providers.dart';
import 'theater_rive.dart';

class PopupAnimationsView extends ConsumerStatefulWidget {
  const PopupAnimationsView({
    Key? key,
    required this.controller,
    required this.chase,
  }) : super(key: key);

  final YoutubePlayerController controller;
  final Chase chase;

  @override
  ConsumerState<PopupAnimationsView> createState() =>
      _PopupAnimationsViewState();
}

class _PopupAnimationsViewState extends ConsumerState<PopupAnimationsView> {
  Widget animatingChild = SizedBox.shrink(key: UniqueKey());
  late PopUpAnimationMetaData popUpAnimationMetaData;
  Alignment prevAlignment = Alignment.center;
  Alignment nextAlignment = Alignment.center;
  Timer timer = Timer(Duration.zero, () {});
  late Timer periodicTimer;
  bool isReady = false;

  // late final StreamController<PopUpAnimationMetaData> streamController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref
        .read(chaseEventsNotifierProvider(widget.chase).notifier)
        .streamController
        .stream
        .listen((ChaseAnimationEvent event) {
      dev.log('Event label-->${event.label}');
      setState(() {
        prevAlignment = nextAlignment;
        nextAlignment = event.alignment;
        animatingChild = RiveEmojies(
          animationEvent: event,
          key: UniqueKey(),
        );
        timer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              prevAlignment = nextAlignment;
              nextAlignment = nextAlignment;
              animatingChild = const SizedBox.shrink();
            });
          }
        });
      });
    });

    widget.controller.addListener(() {
      if (!isReady && widget.controller.value.isPlaying) {
        dev.log('Ready');

        if (mounted) {
          setState(() {
            isReady = true;
          });
        }
      }
    });
    // streamController = StreamController<PopUpAnimationMetaData>();

    // streamController.stream.listen((PopUpAnimationMetaData event) {
    //   if (mounted) {
    //     setState(() {
    //       prevAlignment = nextAlignment;

    //       nextAlignment = event.alignment;
    //       animatingChild = RiveEmojies(
    //         emojieArtboard: event,
    //         key: UniqueKey(),
    //       );
    //       timer.cancel();

    //       timer = Timer(const Duration(seconds: 3), () {
    //         if (mounted) {
    //           setState(() {
    //             prevAlignment = nextAlignment;
    //             nextAlignment = nextAlignment;
    //             animatingChild = const SizedBox.shrink();
    //           });
    //         }
    //       });
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // streamController.close();
    // if (isReady) {
    //   periodicTimer.cancel();
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isReady
        ? const SizedBox.shrink()
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            layoutBuilder: (Widget? child, List<Widget> childrens) {
              return Stack(
                children: [
                  Align(
                    alignment: nextAlignment,
                    child: child,
                  ),
                  // Align(
                  //   alignment: prevAlignment,
                  //   child: childrens.isNotEmpty
                  //       ? childrens[0]
                  //       : const SizedBox.shrink(),
                  // ),
                ],
              );
            },
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: animatingChild,
          );
  }
}

class PopUpAnimationMetaData {
  PopUpAnimationMetaData({
    required this.alignment,
    required this.artBoard,
    required this.animations,
  });

  final Alignment alignment;
  final String artBoard;
  final List<String> animations;
}

List<PopUpAnimationMetaData> popUpAnimationsList = [
  PopUpAnimationMetaData(
    alignment: Alignment.topLeft,
    artBoard: 'Mindblown',
    animations: ['Brain_play'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.topCenter,
    artBoard: 'Bullseye',
    animations: ['Dart_board_play'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.topRight,
    artBoard: 'love',
    animations: ['Animation 1'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.centerLeft,
    artBoard: 'Bullseye',
    animations: ['Dart_board_play'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.center,
    artBoard: 'joy',
    animations: ['idle'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.centerRight,
    artBoard: 'Tada',
    animations: ['idle'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.bottomLeft,
    artBoard: 'Onfire',
    animations: ['idle'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.bottomCenter,
    artBoard: 'Tada',
    animations: ['idle'],
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.bottomRight,
    artBoard: 'joy',
    animations: ['idle'],
  ),
];
