import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../../../../shared/util/firebase_collections.dart';

class TheaterRive extends StatefulWidget {
  const TheaterRive({
    Key? key,
  }) : super(key: key);

  @override
  State<TheaterRive> createState() => _TheaterRiveState();
}

class _TheaterRiveState extends State<TheaterRive> {
  late StateMachineController theaterController;
  Future<void> getAnimationsStatus() async {
    animationsCollection
        .doc('theater')
        .snapshots()
        .listen((DocumentSnapshot<Object?> event) {
      final Map<String, dynamic>? data = event.data() as Map<String, dynamic>?;

      if (data != null) {
        final MapEntry<String, dynamic>? triggerState =
            data.entries.toList().singleWhereOrNull(
                  (MapEntry<String, dynamic> state) => state.value as bool,
                );

        if (triggerState != null) {
          playThiState(triggerState.key);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setStateMachine(Artboard artboard) {
    theaterController = StateMachineController.fromArtboard(artboard, 'Crowd')!;
    artboard.addController(theaterController);
    getAnimationsStatus();
  }

  void playThiState(String state) {
    if (theaterController.isActive) {
      final SMITrigger stateTrigger =
          theaterController.findInput<bool>(state) as SMITrigger;
      stateTrigger.fire();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    theaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.network(
      'https://github.com/chase-app/flutter-rive/blob/main/assets/animations/chase_app.riv?raw=true',
      stateMachines: const ['Theater'],
      fit: BoxFit.cover,
      antialiasing: false,
      alignment: Alignment.bottomCenter,
      onInit: setStateMachine,
    );
  }
}

class RiveEmojies extends StatefulWidget {
  const RiveEmojies({
    Key? key,
    required this.animationEvent,
  }) : super(key: key);

  final ChaseAnimationEvent animationEvent;

  @override
  State<RiveEmojies> createState() => _RiveEmojiesState();
}

class _RiveEmojiesState extends State<RiveEmojies> {
  // late RiveAnimationController _controller;

  // void setStateMachine(Artboard artboard) {
  //   const Type riveFile = RiveFile;
  // }

  @override
  void initState() {
    super.initState();
    // _controller = SimpleAnimation(
    //   'Animation 1',
    //   // onStop: () => setState(() => _isPlaying = false),
    //   // onStart: () => setState(() => _isPlaying = true),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).orientation == Orientation.landscape
          ? 100
          : 50,
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 100
          : 50,
      child: RiveAnimation.asset(
        widget.animationEvent.endpoint,
        fit: BoxFit.cover,

        artboard: widget.animationEvent.artboard,
        animations: [widget.animationEvent.animation],
        antialiasing: false,
        // controllers: [_controller],

        alignment: Alignment.bottomCenter,
        // onInit: setStateMachine,
      ),
    );
  }
}
