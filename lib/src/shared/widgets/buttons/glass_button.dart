import 'dart:ui';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: primaryColor.shade500.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              kPaddingSmallConstant / 2,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
