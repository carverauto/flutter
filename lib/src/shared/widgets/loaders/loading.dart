import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class CircularAdaptiveProgressIndicatorWithBg extends StatelessWidget {
  const CircularAdaptiveProgressIndicatorWithBg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        padding: EdgeInsets.all(kPaddingSmallConstant / 2),
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class CircularAdaptiveProgressIndicator extends StatelessWidget {
  const CircularAdaptiveProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
