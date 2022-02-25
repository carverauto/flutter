import 'package:chaseapp/src/const/other.dart';
import 'package:flutter/material.dart';

class ButtonScaleAnimationWidget extends StatelessWidget {
  const ButtonScaleAnimationWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: Duration(milliseconds: 300),
      curve: primaryCurve,
      child: child,
      builder: (context, animation, child) {
        return Transform.scale(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
