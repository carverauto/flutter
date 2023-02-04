import 'package:flutter/material.dart';

import '../../../../const/colors.dart';
import '../../../../const/other.dart';
import '../../../../const/sizings.dart';

class WatchYoutubeVideo extends StatefulWidget {
  const WatchYoutubeVideo({
    super.key,
    required this.isLive,
  });

  final bool isLive;

  @override
  State<WatchYoutubeVideo> createState() => _WatchYoutubeVideoState();
}

class _WatchYoutubeVideoState extends State<WatchYoutubeVideo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..drive(CurveTween(curve: kPrimaryCurve))
      ..repeat();

    if (!widget.isLive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.isLive ? 'Watch Livestream!' : 'Watch video!',
      child: Container(
        height: 34,
        width: 64,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(
            kBorderRadiusMediumConstant,
          ),
          boxShadow: const [
            BoxShadow(
              color: primaryShadowColor,
              blurRadius: blurValue,
            ),
          ],
        ),
        child: !widget.isLive
            ? const Icon(
                Icons.play_arrow_rounded,
              )
            : AnimatedBuilder(
                animation: _controller,
                child: const Icon(
                  Icons.play_arrow_rounded,
                ),
                builder: (BuildContext context, Widget? child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: _controller.value * 100,
                        width: _controller.value * 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(
                            kBorderRadiusMediumConstant,
                          ),
                        ),
                      ),
                      child!,
                    ],
                  );
                },
              ),
      ),
    );
  }
}
