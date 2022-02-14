import 'dart:math';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:flutter/material.dart';

class GradientAnimationChildBuilder extends StatefulWidget {
  const GradientAnimationChildBuilder({
    Key? key,
    required this.child,
    required this.shouldAnimate,
  }) : super(key: key);

  final Widget child;
  final bool shouldAnimate;

  @override
  _GradientAnimationChildBuilderState createState() =>
      _GradientAnimationChildBuilderState();
}

class _GradientAnimationChildBuilderState
    extends State<GradientAnimationChildBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> rotationAnimation;
  late final Animation<double> containerPaddingAnimation;

  SIGNINMETHOD? signinmethod = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    rotationAnimation = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.decelerate,
      ),
    );

    animationController.addListener(() {
      if (animationController.isCompleted) {
        if (mounted) animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shouldAnimate) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(widget.shouldAnimate ? 5 : 0),
          decoration: BoxDecoration(
            boxShadow: kElevationToShadow["12"],
            gradient: widget.shouldAnimate
                ? LinearGradient(
                    transform: GradientRotation(rotationAnimation.value),
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(
              kBorderRadiusStandard,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
