import 'package:flutter/material.dart';

import '../../../const/sizings.dart';

class ShimmerTile extends StatefulWidget {
  const ShimmerTile({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  State<ShimmerTile> createState() => _ShimmerTileState();
}

class _ShimmerTileState extends State<ShimmerTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> shimmerAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    shimmerAnimation = Tween<double>(
      begin: 1,
      end: 0,
    )
        .chain(CurveTween(curve: const Interval(0, 0.5)))
        .animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kItemsSpacingMediumConstant,
      ),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusStandard),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                // transform: const GradientRotation(pi / 4),
                colors: const [
                  Colors.white38,
                  Colors.white70,
                  Colors.white38,
                ],
                stops: [
                  0.0,
                  shimmerAnimation.value,
                  1.0,
                ],
              ),
            ),
            height: widget.height,
          );
        },
      ),
    );
  }
}
