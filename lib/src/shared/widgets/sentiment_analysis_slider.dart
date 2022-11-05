import 'package:flutter/material.dart';

import '../../const/colors.dart';
import '../../const/sizings.dart';
import '../../models/chase/chase.dart';

class SentimentSlider extends StatelessWidget {
  const SentimentSlider({Key? key, required this.chase}) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    final num? value = chase.sentiment?['score'] as num?;

    return value == null || value == 0
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info,
                color: Colors.yellow,
              ),
              const SizedBox(
                width: kItemsSpacingSmallConstant,
              ),
              Text(
                'NA',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '😬',
                style: Theme.of(context).textTheme.headline6,
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    minWidth: 144,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kItemsSpacingSmallConstant,
                    ),
                    child: CustomPaint(
                      painter: SentimentSliverPainter(value: value),
                      size: const Size(double.maxFinite, 14),
                    ),
                  ),
                ),
              ),
              Text(
                '😂',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          );
  }
}

class SentimentSliverPainter extends CustomPainter {
  SentimentSliverPainter({
    required this.value,
  });

  final num value;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [
          sentimentColor,
          primaryColor.shade600.withOpacity(0.7),
        ],
        stops: [
          value.abs().toDouble(),
          value.abs().toDouble(),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
