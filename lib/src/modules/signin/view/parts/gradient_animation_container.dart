import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../const/other.dart';
import '../../../../const/sizings.dart';
import '../../../../shared/enums/social_logins.dart';

class GradientAnimationChildBuilder extends StatefulWidget {
  const GradientAnimationChildBuilder({
    Key? key,
    required this.child,
    required this.shouldAnimate,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final bool shouldAnimate;
  final EdgeInsets? padding;

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

  SIGNINMETHOD? signinmethod;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    rotationAnimation = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: kPrimaryCurve,
      ),
    );

    animationController.addListener(() {
      if (animationController.isCompleted) {
        if (mounted) {
          animationController.repeat();
        }
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((Duration t) {
      if (widget.shouldAnimate) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });

    return !widget.shouldAnimate
        ? widget.child
        : AnimatedBuilder(
            animation: animationController,
            child: Padding(
              padding: widget.padding ??
                  EdgeInsets.all(widget.shouldAnimate ? 5 : 0),
              child: widget.child,
            ),
            builder: (BuildContext context, Widget? child) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: kElevationToShadow['12'],
                  gradient: widget.shouldAnimate
                      ? LinearGradient(
                          transform: GradientRotation(rotationAnimation.value),
                          colors: const [
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

class IconFloatingAnimation extends StatefulWidget {
  const IconFloatingAnimation({
    Key? key,
    required this.child,
    required this.shouldAnimate,
  }) : super(key: key);

  final Widget child;
  final bool shouldAnimate;

  @override
  State<IconFloatingAnimation> createState() => _IconFloatingAnimationState();
}

class _IconFloatingAnimationState extends State<IconFloatingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> rotationAnimation;
  late final Animation<double> containerPaddingAnimation;

  SIGNINMETHOD? signinmethod;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationController.addListener(() {
      if (animationController.isCompleted) {
        if (mounted) {
          animationController.repeat(reverse: true);
        }
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((Duration t) {
      if (widget.shouldAnimate) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });

    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: animationController.value * 10,
          ),
          child: child,
        );
      },
    );
  }
}
