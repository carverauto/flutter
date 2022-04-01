import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
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
  int finishedIndex = 0;
  Timer timer = Timer(Duration.zero, () {});
  bool isReady = false;

  void setRecursiveTimer() {
    if (finishedIndex < chaseAnimationEvents.length - 1) {
      final int prevTimerDuration = finishedIndex - 1 < 0
          ? 0
          : chaseAnimationEvents[finishedIndex - 1].label;
      final int nextTimerDuration = chaseAnimationEvents[finishedIndex].label;
      final int timerDuration = nextTimerDuration - prevTimerDuration;

      timer = Timer(Duration(milliseconds: timerDuration), () {
        if (mounted) {
          // ref
          //     .read(chaseEventsNotifierProvider(widget.chase.id).notifier)
          //     .streamController
          //     .add(chaseAnimationEvents[finishedIndex]);
          ref
              .read(popupsEvetnsStreamControllerProvider)
              .add(chaseAnimationEvents[finishedIndex]);

          setState(() {
            finishedIndex += 1;
          });
          setRecursiveTimer();
        }
      });
    }
  }

  void listener() {
    if (!widget.controller.value.isPlaying) {
      if (timer.isActive) {
        timer.cancel();
      }
    } else if (widget.controller.value.isPlaying) {
      if (!timer.isActive) {
        setRecursiveTimer();
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

  Future<void> fetchAnimationEvents() async {
    chaseAnimationEvents = await ref
        .read(chaseEventsNotifierProvider(widget.chase.id).notifier)
        .fetchAnimationEvents();
    setState(() {});
    // if (chaseAnimationEvents.isNotEmpty) {
    //   setRecursiveTimer();
    // }

    widget.controller.addListener(listener);

    // final int duration = widget.controller.value.position.inMilliseconds;
    // log(duration.toString());
    // if (!timer.isActive) {
    //   final ChaseAnimationEvent? matchedEvent =
    //       chaseAnimationEvents.singleWhereOrNull((ChaseAnimationEvent event) {
    //     return duration >= event.label - 300 || duration <= event.label + 300;
    //   });
    //   if (matchedEvent != null) {
    //     ref
    //         .read(chaseEventsNotifierProvider(widget.chase).notifier)
    //         .streamController
    //         .add(matchedEvent);
    //   }

    //   timer.cancel();

    //   timer = Timer(const Duration(milliseconds: 300), () {});
    // }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bool isLive = widget.chase.live ?? true;
    if (!isLive) {
      Future<void>.microtask(fetchAnimationEvents);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    // ref
    //     .read(chaseEventsNotifierProvider(widget.chase).notifier)
    //     .streamController
    //     .close();

    widget.controller.removeListener(listener);

    // ref
    //     .read(chaseEventsNotifierProvider(widget.chase).notifier)
    //     .streamController
    //     .close();

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
