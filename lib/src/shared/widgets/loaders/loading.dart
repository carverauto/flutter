import 'package:flutter/material.dart';

class CircularAdaptiveProgressIndicator extends StatelessWidget {
  const CircularAdaptiveProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
