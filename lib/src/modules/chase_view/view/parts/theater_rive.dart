import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:rive/rive.dart';

import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../../../../shared/util/firebase_collections.dart';
import '../providers/providers.dart';

class TheaterRive extends ConsumerStatefulWidget {
  const TheaterRive({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<TheaterRive> createState() => _TheaterRiveState();
}

class _TheaterRiveState extends ConsumerState<TheaterRive> {
  final Logger logger = Logger('TheaterRiveAnimationView');
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

  void eventListener(ChaseAnimationEvent event) {
    playThiState(event.animstate);
  }

  @override
  void initState() {
    super.initState();
    ref.refresh(theaterEvetnsStreamControllerProvider);

    ref
        .read(theaterEvetnsStreamControllerProvider)
        .stream
        .listen(eventListener);
  }

  void setStateMachine(Artboard artboard) {
    theaterController = StateMachineController.fromArtboard(artboard, 'Crowd')!;
    artboard.addController(theaterController);
    getAnimationsStatus();
  }

  void playThiState(String state) {
    if (theaterController.isActive) {
      final SMITrigger? stateTrigger =
          theaterController.findInput<bool>(state) as SMITrigger?;
      if (stateTrigger != null) {
        stateTrigger.fire();
      } else {
        logger.warning('Provided Animation state is not valid.');
      }
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
