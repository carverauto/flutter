import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreditsView extends ConsumerStatefulWidget {
  const CreditsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreditsViewState();
}

class _CreditsViewState extends ConsumerState<CreditsView>
    with SingleTickerProviderStateMixin {
  final String crawlText =
      '''Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute.

Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo.

While the Congress of the Republic endlessly debates this alarming chain of events,the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict....''';

  late final AnimationController _animationController;

  late final Animation<Offset> crawlTextposition;

  late final Animation<double> disappearCrawlText;

  late AudioCache audioPlayer = AudioCache(
    fixedPlayer: AudioPlayer(),
  );

  void playAnimation() async {
    final height = MediaQuery.of(context).size.height;
    final topOffset = height;
    final bottomOffset = -height * 0.8;
    crawlTextposition =
        Tween(begin: Offset(0, topOffset), end: Offset(0, bottomOffset))
            .animate(_animationController);
    disappearCrawlText = Tween<double>(begin: 1.0, end: 0)
        .chain(
          CurveTween(
            curve: Interval(0.95, 1.0),
          ),
        )
        .animate(_animationController);
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
    await Future<void>.delayed(Duration(milliseconds: 500));
    await audioPlayer.play(
      "audio/about_music.mp3",
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
    audioPlayer.fixedPlayer!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            clipBehavior: Clip.none,
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
          )),
    );
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
        width: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.4, //370,
        child: Transform(
          origin: Offset(
            MediaQuery.of(context).size.width / 2 -
                (Sizescaleconfig.getDeviceType == DeviceType.MOBILE
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.6) /
                    2, //540,
            150,
          ),
          transform: Matrix4.identity()
            ..setRotationX(
              pi / 2.7, //2.8, //2.5,
            )
            ..setEntry(
              3,
              1,
              -0.001,
            ),
          child: AnimatedBuilder(
              animation: _animationController,
              child: CrawlContributions(
                animationController: _animationController,
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

class CrawlContributions extends StatelessWidget {
  CrawlContributions({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final crawlBodyTextStyle = TextStyle(
      height: 1.3,
      fontSize: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
          ? Theme.of(context).textTheme.bodyText1!.fontSize
          : Theme.of(context).textTheme.subtitle1!.fontSize,
      color: starWarsCrawlTextColor,
      fontFamily: "Crawl",
    );

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final maxdrag = details.primaryDelta! / Sizescaleconfig.screenheight!;

        final isScrolledDown = maxdrag.isNegative;

        final animationValue = animationController.value;
        animationController
            .animateTo(
          isScrolledDown ? (animationValue + 0.1) : (animationValue - 0.1),
          duration: Duration(milliseconds: 300),
        )
            .then((value) {
          if (!isScrolledDown) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        });
      },
      child: ListView(
        clipBehavior: Clip.none,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            "ChaseApp Development Credits",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.3,
              fontSize: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
                  ? Theme.of(context).textTheme.subtitle1!.fontSize
                  : Theme.of(context).textTheme.headline5!.fontSize,
              color: starWarsCrawlTextColor,
              fontFamily: "Crawl",
            ),
          ),
          Divider(
            height: kItemsSpacingMediumConstant,
            color: Colors.white,
            indent: kPaddingSmallConstant,
            endIndent: kPaddingSmallConstant,
            thickness: 1,
          ),
          Text(
            "A special thank you goes out to all those that have helped contribute code, ideas, and with the overall care and feeding of the system, we salute you.",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: crawlBodyTextStyle,
          ),
          SizedBox(
            height: kItemsSpacingSmallConstant,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "# ",
                style: crawlBodyTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: "Chases IRC team",
                style: crawlBodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 10,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ]),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "# ",
                style: crawlBodyTextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: "Chases Private Channel",
                style: crawlBodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 10,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ]),
          ),
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount:
                Sizescaleconfig.getDeviceType == DeviceType.MOBILE ? 2 : 3,
            children: [
              CustomAvatar(
                name: "Acidjazz",
                link: "https://github.com/acidjazz",
              ),
              CustomAvatar(
                name: "Rutvik",
                link: "https://github.com/rutvik110",
              ),
              CustomAvatar(
                name: "Michael",
                link: "https://github.com/mfreeman451",
              ),
              CustomAvatar(
                name: "Cottongin",
                link: "https://github.com/cottongin",
              ),
              CustomAvatar(
                name: "Pilate",
                link: "https://github.com/pilate",
              ),
            ],
          ),
          Divider(
            height: kItemsSpacingMediumConstant,
            color: Colors.white,
            thickness: 1,
            indent: kPaddingSmallConstant,
            endIndent: kPaddingSmallConstant,
          ),
          Text(
            "Thank You!",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.3,
              fontSize: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
                  ? Theme.of(context).textTheme.subtitle1!.fontSize
                  : Theme.of(context).textTheme.headline5!.fontSize,
              color: starWarsCrawlTextColor,
              fontFamily: "Crawl",
            ),
          ),
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
        ],
      ),
    );
  }
}

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    Key? key,
    required this.name,
    required this.link,
  }) : super(key: key);

  final String name;
  final String link;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
          ? Theme.of(context).textTheme.overline!.fontSize
          : Theme.of(context).textTheme.button!.fontSize,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          launchUrl(link);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: starWarsCrawlTextColor,
              child: Text(
                name.characters.first.toUpperCase(),
              ),
            ),
            Flexible(
              child: Chip(
                backgroundColor: Colors.white.withOpacity(
                  0.8,
                ),
                avatar: Icon(
                  Icons.link,
                  color: starWarsCrawlTextColor,
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 2),
                label: Text(
                  name,
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: starWarsCrawlTextColor,
                  ),
                ),
              ),
            ),
          ],
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
      top: Sizescaleconfig.screenheight! * 0.02,
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
