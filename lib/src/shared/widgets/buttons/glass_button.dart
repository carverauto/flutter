import 'dart:ui';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurValue,
          sigmaY: blurValue,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: primaryColor.shade500.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.all(
                  kPaddingSmallConstant / 2,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
