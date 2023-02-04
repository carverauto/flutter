import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../const/colors.dart';
import '../../../const/sizings.dart';

class GlassButton extends StatelessWidget {
  const GlassButton({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GlassBGPainter(),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ??
              const EdgeInsets.all(
                kPaddingSmallConstant / 2,
              ),
          child: child,
        ),
      ),
    );
  }
}

class GlassBg extends StatelessWidget {
  const GlassBg({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GlassBGPainter(
        blureBg: true,
        color: color,
      ),
      child: Padding(
        padding: padding ??
            const EdgeInsets.all(
              kPaddingSmallConstant / 2,
            ),
        child: child,
      ),
    );
  }
}

class GlassBGPainter extends CustomPainter {
  GlassBGPainter({
    this.blureBg = false,
    this.color,
  });
  final bool blureBg;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color ?? (primaryColor.shade600).withOpacity(0.3)
      ..imageFilter = blureBg
          ? ImageFilter.blur(
              sigmaX: blurValue,
              sigmaY: blurValue,
            )
          : null
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(kBorderRadiusStandard),
    );

    canvas
      ..clipRRect(rrect)
      ..drawPaint(paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
