import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rive/rive.dart';

import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../providers/providers.dart';

class TheaterRive extends ConsumerStatefulWidget {
  const TheaterRive({
    super.key,
  });

  @override
  ConsumerState<TheaterRive> createState() => _TheaterRiveState();
}

class _TheaterRiveState extends ConsumerState<TheaterRive> {
  final Logger logger = Logger('TheaterRiveAnimationView');
  late StateMachineController theaterController;
  late String riveFile;
  late String? animstate;
  bool isInitialized = false;
  late Artboard artboard;
  Timer timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    riveFile =
        'https://github.com/chase-app/flutter-rive/blob/main/assets/animations/chase_app.riv?raw=true';
    animstate = null;
    ref.refresh(theaterEvetnsStreamControllerProvider);

    ref
        .read(theaterEvetnsStreamControllerProvider)
        .stream
        .listen(eventListener);
  }

  // Future<void> getAnimationsStatus() async {
  //   animationsCollection
  //       .doc('theater')
  //       .snapshots()
  //       .listen((DocumentSnapshot<Object?> event) {
  //     final Map<String, dynamic>? data = event.data() as Map<String, dynamic>?;

  //     if (data != null) {
  //       final MapEntry<String, dynamic>? triggerState =
  //           data.entries.toList().singleWhereOrNull(
  //                 (MapEntry<String, dynamic> state) => state.value as bool,
  //               );

  //       if (triggerState != null) {
  //         playThiState(triggerState.key);
  //       }
  //     }
  //   });
  // }

  void eventListener(ChaseAnimationEvent event) {
    if (event.endpoint == riveFile) {
      playThiState(event.animstate);
    } else {
      setState(() {
        riveFile = event.endpoint;
        animstate = event.animstate;
      });
      // playThiState(event.animstate);
    }
  }

  void setStateMachine(Artboard riveArtboard) {
    artboard = riveArtboard;
    theaterController = StateMachineController.fromArtboard(artboard, 'Crowd')!;

    isInitialized = true;
    if (animstate != null) {
      playThiState(animstate!);
      animstate = null;
    }
  }

  Future<void> playThiState(String state) async {
    timer.cancel();
    artboard.addController(theaterController);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (theaterController.isActive) {
      final SMITrigger? stateTrigger =
          theaterController.findInput<bool>(state) as SMITrigger?;
      if (stateTrigger != null) {
        stateTrigger.fire();
      } else {
        logger.warning('Provided Animation state is not valid.');
      }
    }
    timer = Timer(const Duration(seconds: 5), () {
      artboard.removeController(theaterController);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    if (isInitialized) {
      theaterController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.network(
      riveFile,
      // stateMachines: const ['Theater'],
      fit: BoxFit.cover,
      antialiasing: false,
      alignment: Alignment.bottomCenter,
      onInit: setStateMachine,
    );
  }
}
