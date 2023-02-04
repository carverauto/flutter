import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../../../const/sizings.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    super.key,
  });

  @override
  State<CountDownTimer> createState() => _MyShaderState();
}

class _MyShaderState extends State<CountDownTimer>
    with SingleTickerProviderStateMixin {
  // late Future<AnimatingGradient> helloWorld;

  late Ticker ticker;

  late double delta;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 3),
    )..repeat(reverse: true);
    animation = Tween<double>(begin: 0, end: 180).animate(animationController);
    // helloWorld = AnimatingGradient.compile();
    delta = 0;
    animationController.addListener(() {
      setState(() {});
    });
    // ticker = Ticker((Duration elapsedTime) {
    //   setState(() {
    //     delta += 1 / 60;
    //   });
    // })
    //   ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: SizedBox(
        width: 120,
        child: Center(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius:
                  BorderRadius.all(Radius.circular(kBorderRadiusSmallConstant)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPaddingSmallConstant),
              child: Text(
                DateFormat('mm:ss').format(
                  DateTime.now().copyWith(
                    minute: 0,
                    second: animation.value.toInt(),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'digital_7',
                  color: Colors.greenAccent,
                  fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
