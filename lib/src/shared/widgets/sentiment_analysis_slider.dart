import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:flutter/material.dart';

class SentimentSlider extends StatelessWidget {
  const SentimentSlider({Key? key, required this.chase}) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    final num? value = chase.sentiment?["score"] as num?;
    return value == null || value == 0
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info,
                color: Colors.yellow,
              ),
              SizedBox(
                width: kItemsSpacingSmallConstant,
              ),
              Text(
                "NA",
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
                "😬",
                style: Theme.of(context).textTheme.headline6,
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 200,
                    minWidth: 144,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 13,
                        margin: EdgeInsets.symmetric(
                          horizontal: kItemsSpacingSmallConstant,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor.shade600.withOpacity(0.7),
                          gradient: LinearGradient(colors: [
                            sentimentColor,
                            primaryColor.shade600.withOpacity(0.7),
                          ], stops: [
                            value.abs().toDouble(),
                            value.abs().toDouble(),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "😂",
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          );
  }
}
