library medium_clap_flutter;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../const/images.dart';
import '../../../const/sizings.dart';

/// A Custom Floating Action Button (FAB) library like clapping effect on Medium.
class ClapFAB extends StatefulWidget {
  const ClapFAB.icon({
    super.key,
    this.countCircleColor = Colors.blue,
    this.countTextColor = Colors.white,
    this.hasShadow = false,
    this.shadowColor = Colors.blue,
    this.floatingOutlineColor = Colors.white,
    this.floatingBgColor = Colors.white,
    this.defaultIcon = Icons.favorite_border,
    this.defaultIconColor = Colors.blue,
    this.sparkleColor = Colors.blue,
    this.filledIcon = Icons.favorite,
    this.filledIconColor = Colors.blue,
    this.initCounter = 0,
    this.maxCounter = NOT_LIMIT_INCREMENT,
    required this.clapFabCallback,
    this.clapUpCallback,
    required this.trailing,
  })  : defaultImage = null,
        defaultImageColor = null,
        filledImage = null,
        filledImageColor = null;

  const ClapFAB.image({
    super.key,
    this.countCircleColor = Colors.blue,
    this.countTextColor = Colors.white,
    this.hasShadow = false,
    this.shadowColor = Colors.blue,
    this.floatingOutlineColor = Colors.white,
    this.floatingBgColor = Colors.white,
    this.sparkleColor = Colors.blue,
    this.defaultImage = 'images/clap.png',
    this.defaultImageColor = Colors.blue,
    this.filledImageColor = Colors.blue,
    this.filledImage = 'images/clap.png',
    this.initCounter = 0,
    this.maxCounter = NOT_LIMIT_INCREMENT,
    required this.clapFabCallback,
    this.clapUpCallback,
    required this.trailing,
  })  : defaultIcon = null,
        defaultIconColor = null,
        filledIcon = null,
        filledIconColor = null;
  static const int NOT_LIMIT_INCREMENT = -1;

  /// The color of count's circle background
  final Color countCircleColor;

  /// The color of count's circle text
  final Color countTextColor;

  /// Whether to have shadow or not around ClapFab button
  final bool hasShadow;

  /// The color of the shadow
  final Color shadowColor;

  /// The outline color/ border color of the ClabFab button
  final Color floatingOutlineColor;

  /// The Background color of the ClabFab button
  final Color floatingBgColor;

  /// The color of sparkels around the count
  final Color sparkleColor;

  /// The default icon of the ClapFab button
  final IconData? defaultIcon;

  /// The color of default icon of the ClapFab button
  final Color? defaultIconColor;

  /// The filled icon after clapping of the ClapFab button
  final IconData? filledIcon;

  /// The filled icon color after clapping of the ClapFab button
  final Color? filledIconColor;

  /// On Tap Down callback
  final void Function(int upCount) clapFabCallback;

  /// On Tap Up callback
  final Function(int upCount)? clapUpCallback;

  /// The default image of the ClapFab button
  final String? defaultImage;

  /// The color of default image of the ClapFab button
  final Color? defaultImageColor;

  /// The filled image after clapping of the ClapFab button
  final String? filledImage;

  /// The color of filled image of the ClapFab button
  final Color? filledImageColor;

  /// Starting counter value (default 0)
  final int initCounter;

  /// Maximum counter value (default SHOULD_NOT_INCREMENT, which will not limit increment)
  final int maxCounter;

  final Widget Function(int votes) trailing;

  @override
  _ClapFABState createState() => _ClapFABState();
}

enum ScoreWidgetStatus { HIDDEN, BECOMING_VISIBLE, VISIBLE, BECOMING_INVISIBLE }

class _ClapFABState extends State<ClapFAB> with TickerProviderStateMixin {
  int counter = 0;
  int upCount = 0;
  double _sparklesAngle = 0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final Duration duration = const Duration(milliseconds: 400);
  final Duration oneSecond = const Duration(seconds: 1);
  late Random random;
  // Timer ?holdTimer, scoreOutETA;
  Timer holdTimer = Timer(const Duration(), () {});
  late Timer scoreOutETA;
  bool isScoreOutTimerInitialized = false;
  late AnimationController scoreInAnimationController,
      scoreOutAnimationController,
      scoreSizeAnimationController,
      sparklesAnimationController;
  late Animation<double> scoreOutPositionAnimation, sparklesAnimation;

  @override
  initState() {
    super.initState();
    random = Random();
    counter = widget.initCounter;
    scoreInAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener(() {
      setState(() {}); // Calls render function
    });

    scoreOutAnimationController =
        AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = Tween<double>(begin: 100, end: 150).animate(
      CurvedAnimation(
        parent: scoreOutAnimationController,
        curve: Curves.easeOut,
      ),
    );
    scoreOutPositionAnimation.addListener(() {
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    scoreSizeAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener(() {
      setState(() {});
    });

    sparklesAnimationController =
        AnimationController(vsync: this, duration: duration);
    sparklesAnimation = CurvedAnimation(
      parent: sparklesAnimationController,
      curve: Curves.easeIn,
    );
    sparklesAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    scoreInAnimationController.dispose();
    scoreOutAnimationController.dispose();
    super.dispose();
  }

  void increment() {
    scoreSizeAnimationController.forward(from: 0);
    sparklesAnimationController.forward(from: 0);

    if (_shouldIncrement()) {
      setState(() {
        upCount++;
        counter++;
        _sparklesAngle = random.nextDouble() * (2 * pi);
      });
    }
  }

  bool _shouldIncrement() => widget.maxCounter == ClapFAB.NOT_LIMIT_INCREMENT
      ? true
      : counter < widget.maxCounter;

  void onTapDown(TapDownDetails tap) {
    holdTimer.cancel();
    increment();
    // User pressed the button. This can be a tap or a hold.
    if (isScoreOutTimerInitialized) {
      scoreOutETA.cancel(); // We do not want the score to vanish!
    }
    if (_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      // We tapped down while the widget was flying up. Need to cancel that animation.
      scoreOutAnimationController.stop();
      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
    } else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
      scoreInAnimationController.forward(from: 0);
    }

    holdTimer = Timer(const Duration(milliseconds: 500), () {
      print('message');
      setState(() {
        widget.clapFabCallback(upCount);
        upCount = 0;
      });
    }); // Takes care of hold
  }

  void onTapUp(TapUpDetails tap) {
    // User removed his finger from button.

    scoreOutETA = Timer(oneSecond, () {
      scoreOutAnimationController.forward(from: 0);
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
    });
    isScoreOutTimerInitialized = true;
    setState(() {});
    if (widget.clapUpCallback != null) widget.clapUpCallback!(counter);
    // holdTimer.cancel();
  }

  Widget getClapButton() {
    // Using custom gesture detector because we want to keep increasing the claps
    // when user holds the button.

    return GestureDetector(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: widget.floatingOutlineColor),
          shape: BoxShape.circle,
          color: widget.floatingBgColor,
          boxShadow: [
            if (widget.hasShadow)
              BoxShadow(
                color: widget.shadowColor.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(
                  0,
                  4,
                ),
              )
            else
              const BoxShadow()
          ],
        ),
        child: SvgPicture.asset(
          donutSVG,
          height: kIconSizeMediumConstant,
        ),
      ),
    );
  }

  Widget getScoreButton() {
    double scorePosition = 0;
    double scoreOpacity = 0;
    double extraSize = 0;
    switch (_scoreWidgetStatus) {
      case ScoreWidgetStatus.HIDDEN:
        break;
      case ScoreWidgetStatus.BECOMING_VISIBLE:
      case ScoreWidgetStatus.VISIBLE:
        scorePosition = scoreInAnimationController.value * 100;
        scoreOpacity = scoreInAnimationController.value;
        extraSize = scoreSizeAnimationController.value * 3;
        break;
      case ScoreWidgetStatus.BECOMING_INVISIBLE:
        scorePosition = scoreOutPositionAnimation.value;
        scoreOpacity = 1.0 - scoreOutAnimationController.value;
    }

    final List<Widget> stackChildren = <Widget>[];

    final double firstAngle = _sparklesAngle;
    final double sparkleRadius = sparklesAnimationController.value * 50;
    final double sparklesOpacity = 1 - sparklesAnimation.value;

    for (int i = 0; i < 5; ++i) {
      final double currentAngle = firstAngle + ((2 * pi) / 5) * i;
      final Positioned sparklesWidget = Positioned(
        left: (sparkleRadius * cos(currentAngle)) + 20,
        top: (sparkleRadius * sin(currentAngle)) + 20,
        child: Transform.rotate(
          angle: currentAngle - pi / 2,
          child: Opacity(
            opacity: sparklesOpacity,
            child: Image.asset(
              'images/sparkles.png',
              color: widget.sparkleColor,
              cacheHeight: 28,
              cacheWidth: 28,
              width: 14,
              height: 14,
            ),
          ),
        ),
      );
      stackChildren.add(sparklesWidget);
    }

    stackChildren.add(
      Opacity(
        opacity: scoreOpacity,
        child: Container(
          height: 50.0 + extraSize,
          width: 50.0 + extraSize,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: widget.countCircleColor,
          ),
          alignment: Alignment.center,
          child: Text(
            '+$counter',
            style: TextStyle(
              color: widget.countTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );

    final Positioned currentWidget = Positioned(
      bottom: scorePosition,
      child: Stack(
        alignment: FractionalOffset.center,
        clipBehavior: Clip.none,
        children: stackChildren,
      ),
    );
    return currentWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN)
          Flexible(
            child: widget.trailing(counter),
          ),
        const SizedBox(
          width: kItemsSpacingSmallConstant,
        ),
        Stack(
          alignment: FractionalOffset.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            getScoreButton(),
            getClapButton(),
          ],
        ),
      ],
    );
  }
}
