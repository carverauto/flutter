import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../../../../shared/enums/animtype.dart';
import '../providers/providers.dart';
import 'pop_up_animations_overlay.dart';
import 'theater_rive.dart';

class VideoAnimationsOverlay extends ConsumerStatefulWidget {
  const VideoAnimationsOverlay({
    Key? key,
    required this.controller,
    required this.chase,
  }) : super(key: key);

  final YoutubePlayerController controller;
  final Chase chase;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoAnimationsOverlayState();
}

class _VideoAnimationsOverlayState
    extends ConsumerState<VideoAnimationsOverlay> {
  late final List<ChaseAnimationEvent> chaseAnimationEvents;
  Timer timer = Timer(Duration.zero, () {});
  bool isReady = false;

  void setRecursiveTimer() {
    if (timer.isActive) {
      timer.cancel();
    }
    final int position =
        widget.controller.durationNotifier.value.position.inMilliseconds;
    final int nextEventIndex = chaseAnimationEvents.indexWhere(
      (ChaseAnimationEvent event) => event.label >= position,
    );
    if (nextEventIndex != -1) {
      final int timerDuration =
          chaseAnimationEvents[nextEventIndex].label - position;
      log('Event Label ---> ${chaseAnimationEvents[nextEventIndex].label}');

      timer = Timer(
        Duration(milliseconds: timerDuration == 0 ? 100 : timerDuration),
        () {
          if (mounted) {
            final ChaseAnimationEvent animationevent =
                chaseAnimationEvents[nextEventIndex];
            // ref
            //     .read(popupsEvetnsStreamControllerProvider)
            //     .add(chaseAnimationEvents[finishedIndex]);
            if (animationevent.animtype == AnimType.pop_up) {
              ref
                  .read(popupsEvetnsStreamControllerProvider)
                  .add(animationevent);
            } else if (animationevent.animtype == AnimType.theater) {
              ref
                  .read(theaterEvetnsStreamControllerProvider)
                  .add(animationevent);
            } else {
              log('Event type not identified');
            }

            // setState(() {
            //   finishedIndex += 1;
            // });
            setRecursiveTimer();
          }
        },
      );
      // }
    }
  }

  // ignore: long-method
  void listener() {
    if (mounted) {
      log(widget.controller.value.playerState.toString());

      if (widget.controller.value.playerState == PlayerState.buffering) {
        if (timer.isActive) {
          timer.cancel();
        }
      } else if (widget.controller.value.playerState == PlayerState.playing) {
        // if (!timer.isActive) {
        //   setRecursiveTimer();
        // }

        if (!timer.isActive) {
          setRecursiveTimer();
          // setRecursiveTimer();
          // position
          // if (!isDragged) {
          //   if (finishedIndex <= chaseAnimationEvents.length - 1) {
          //     setState(() {
          //       finishedIndex += 1;
          //       isDragged = false;
          //     });

          //     setRecursiveTimer();
          //   }
          // } else {
          //   final int position = widget
          //       .controller.durationNotifier.value.position.inMilliseconds;
          //   final int nextEventIndex = chaseAnimationEvents.indexWhere(
          //     (ChaseAnimationEvent event) => event.label >= position,
          //   );
          //   if (nextEventIndex != -1) {
          //     final int timerDuration =
          //         chaseAnimationEvents[nextEventIndex].label - position;
          //     setState(() {
          //       finishedIndex = nextEventIndex;
          //       isDragged = false;
          //       // finishedIndex += 1;
          //     });
          //     log('Next index--->${nextEventIndex}Label---> ${chaseAnimationEvents[nextEventIndex].label}');

          //     setRecursiveTimer(timerDuration);
          //   }
          // }
          // if (isDragged) {
          //   setState(() {
          //     isDragged = false;
          //   });
          // }
        }
      } else if (widget.controller.value.playerState == PlayerState.paused) {
        // if (widget.controller.value.isDragging) {
        //   if (!isDragged) {
        //     setState(() {
        //       isDragged = widget.controller.value.isDragging;
        //     });
        //   }
        // }
        if (timer.isActive) {
          timer.cancel();
        }
      } else if (widget.controller.value.playerState == PlayerState.ended) {
        if (timer.isActive) {
          timer.cancel();
        }
      } else if (widget.controller.value.isReady) {
        if (!isReady) {
          setState(() {
            isReady = true;
          });
          setRecursiveTimer();
        }
      }
    }
  }

  Future<void> fetchAnimationEvents() async {
    ref.refresh(chaseEventsNotifierProvider(widget.chase.id));
    await Future<void>.delayed(const Duration(milliseconds: 300));

    chaseAnimationEvents = await ref
        .read(chaseEventsNotifierProvider(widget.chase.id).notifier)
        .fetchAnimationEvents();
    if (mounted) {
      setState(() {});
    }

    widget.controller.addListener(listener);
  }

  Future<void> subscribetoAnimationEvents() async {
    ref.refresh(chaseEventsNotifierProvider(widget.chase.id));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await ref
        .read(chaseEventsNotifierProvider(widget.chase.id).notifier)
        .subscribeToEventsStream();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.chase.live != null) {
      if (widget.chase.live!) {
        Future<void>.microtask(subscribetoAnimationEvents);
      } else {
        Future<void>.microtask(fetchAnimationEvents);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    // ref
    //     .read(chaseEventsNotifierProvider(widget.chase.id).notifier)
    //     .unsubscribeFeed();

    widget.controller.removeListener(listener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showOverlay = ref.watch(showVideoOverlayProvider);

    return !showOverlay
        ? const SizedBox.shrink()
        : Stack(
            fit: StackFit.expand,
            children: [
              const Align(
                alignment: Alignment.bottomCenter,
                child: TheaterRive(),
              ),
              PopupAnimationsView(
                controller: widget.controller,
                chase: widget.chase,
              ),
              Positioned(
                top: kItemsSpacingSmallConstant,
                left: kItemsSpacingSmallConstant,
                child: Image(
                  image: const AssetImage(chaseAppTextLogoAsset),
                  height: kImageSizeSmall,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          );
  }
}
