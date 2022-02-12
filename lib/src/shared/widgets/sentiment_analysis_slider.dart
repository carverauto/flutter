import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class SentimentSlider extends StatelessWidget {
  const SentimentSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
            child: Container(
              height: 13,
              margin: EdgeInsets.symmetric(
                horizontal: kItemsSpacingSmallConstant,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
                gradient: LinearGradient(colors: [
                  sentimentColor,
                  primaryColor.shade600.withOpacity(0.7),
                ], stops: [
                  0.6,
                  0.6,
                ]),
              ),
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
