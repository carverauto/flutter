import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class awdaw extends ConsumerStatefulWidget {
  const awdaw({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _awdawState();
}

class _awdawState extends ConsumerState<awdaw> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AboutUsView extends ConsumerStatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends ConsumerState<AboutUsView>
    with SingleTickerProviderStateMixin {
  final String crawlText =
      '''Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute.

Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo.

While the Congress of the Republic endlessly debates this alarming chain of events,the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict....''';

  late final AnimationController _animationController;

  late final Animation<Offset> crawlTextposition;

  late final Animation<double> disappearCrawlText;

  late AudioPlayer audioPlayer = AudioPlayer();

  void playAnimation() async {
    final height = MediaQuery.of(context).size.height;
    final topOffset = height + 100;
    final bottomOffset = -height / 2;
    crawlTextposition =
        Tween(begin: Offset(0, topOffset), end: Offset(0, bottomOffset))
            .animate(_animationController);
    disappearCrawlText = Tween<double>(begin: 1.0, end: 0)
        .chain(
          CurveTween(
            curve: Interval(0.9, 0.95),
          ),
        )
        .animate(_animationController);
    Future.delayed(Duration(milliseconds: 300));
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  Future<void> playTrack() async {
    await audioPlayer.play(
      starWarsIntroMusicUrl,
      isLocal: false,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    playTrack();
  }

  @override
  void didChangeDependencies() {
    playAnimation();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose(); // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/galaxy.png',
                fit: BoxFit.cover,
              ),
            ),
            CrawlText(
              animationController: _animationController,
              crawlText: crawlText,
              crawlTextposition: crawlTextposition,
              disappearCrawlText: disappearCrawlText,
            ),
            BackButton(),
          ],
        ));
  }
}

class CrawlText extends StatelessWidget {
  const CrawlText({
    Key? key,
    required AnimationController animationController,
    required this.crawlText,
    required this.crawlTextposition,
    required this.disappearCrawlText,
  })  : _animationController = animationController,
        super(key: key);

  final AnimationController _animationController;
  final String crawlText;
  final Animation<Offset> crawlTextposition;
  final Animation<double> disappearCrawlText;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3, //370,
        height: 500,
        child: Transform(
          origin: Offset(
            MediaQuery.of(context).size.width / 2 -
                MediaQuery.of(context).size.width * 0.37, //540,
            150,
          ),
          transform: Matrix4.identity()
            ..setRotationX(
              math.pi / 2.6, //2.8, //2.5,
            )
            ..setEntry(
              3,
              1,
              -0.001,
            ),
          child: AnimatedBuilder(
              animation: _animationController,
              child: Text(
                crawlText,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  height: 1.3,
                  fontSize: Theme.of(context).textTheme.subtitle2!.fontSize,
                  color: starWarsCrawlTextColor,
                  fontFamily: "Crawl",
                ),
              ),
              builder: (context, child) {
                return Transform.translate(
                  offset: crawlTextposition.value,
                  child: Opacity(
                    opacity: disappearCrawlText.value,
                    child: child,
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Sizescaleconfig.screenheight! * 0.04,
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            primary: starWarsCrawlTextColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )),
    );
  }
}
