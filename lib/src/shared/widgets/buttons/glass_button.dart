import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../const/colors.dart';
import '../../../const/sizings.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
    this.shape,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: primaryColor.shade500.withOpacity(0.3),
      shape: shape,
      type: MaterialType.button,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            shape != null ? null : BorderRadius.circular(kBorderRadiusStandard),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurValue,
            sigmaY: blurValue,
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
