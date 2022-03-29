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
                  child: Container(
                    height: 14,
                    margin: const EdgeInsets.symmetric(
                      horizontal: kItemsSpacingSmallConstant,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor.shade600.withOpacity(0.7),
                      gradient: LinearGradient(
                        colors: [
                          sentimentColor,
                          primaryColor.shade600.withOpacity(0.7),
                        ],
                        stops: [
                          value.abs().toDouble(),
                          value.abs().toDouble(),
                        ],
                      ),
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
