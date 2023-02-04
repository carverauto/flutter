import 'package:flutter/material.dart';

import '../../../const/sizings.dart';

class CircularAdaptiveProgressIndicatorWithBg extends StatelessWidget {
  const CircularAdaptiveProgressIndicatorWithBg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: const Padding(
          padding: EdgeInsets.all(kPaddingSmallConstant / 2),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class CircularAdaptiveProgressIndicator extends StatelessWidget {
  const CircularAdaptiveProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
