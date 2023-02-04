import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';

class RiveEmojies extends StatefulWidget {
  const RiveEmojies({
    super.key,
    required this.animationEvent,
  });

  final ChaseAnimationEvent animationEvent;

  @override
  State<RiveEmojies> createState() => _RiveEmojiesState();
}

class _RiveEmojiesState extends State<RiveEmojies> {
  @override
  void initState() {
    super.initState();
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
      child: RiveAnimation.network(
        widget.animationEvent.endpoint,
        fit: BoxFit.cover,

        artboard: widget.animationEvent.artboard,
        animations: widget.animationEvent.animations,
        antialiasing: false,
        // controllers: [_controller],

        alignment: widget.animationEvent.alignment,
        // onInit: setStateMachine,
      ),
    );
  }
}
