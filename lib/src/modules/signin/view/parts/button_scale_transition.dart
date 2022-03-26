import 'package:flutter/material.dart';

import '../../../../const/other.dart';

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
      duration: const Duration(milliseconds: 300),
      curve: kPrimaryCurve,
      child: child,
      builder: (BuildContext context, double animation, Widget? child) {
        return Transform.scale(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
