import 'dart:ui';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(kBorderRadiusStandard),
      child: InkWell(
        onTap: onTap,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurValue,
            sigmaY: blurValue,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: primaryColor.shade500.withOpacity(0.1),
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
      ),
    );
  }
}
