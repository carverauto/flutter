import 'package:chaseapp/src/const/colors.dart';
import 'package:flutter/material.dart';

class SentimentSlider extends StatelessWidget {
  const SentimentSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("😬"),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: SliderComponentShape.noOverlay,
              trackHeight: 10,
            ),
            child: Slider(
              value: 0.5,
              onChanged: (v) {},
              activeColor: Colors.green,
              inactiveColor: primaryColor.shade600,
            ),
          ),
        ),
        Text("😂"),
      ],
    );
  }
}
