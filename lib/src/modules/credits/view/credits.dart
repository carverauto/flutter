import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../const/colors.dart';
import '../../../const/sizings.dart';
import '../../../shared/util/helpers/launchLink.dart';
import '../../../shared/util/helpers/sizescaleconfig.dart';

class CreditsView extends ConsumerStatefulWidget {
  const CreditsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreditsViewState();
}

class _CreditsViewState extends ConsumerState<CreditsView>
    with SingleTickerProviderStateMixin {
  final String crawlText = '''
Turmoil has engulfed the Galactic Republic. The taxation of trade routes to outlying star systems is in dispute.

Hoping to resolve the matter with a blockade of deadly battleships, the greedy Trade Federation has stopped all shipping to the small planet of Naboo.

While the Congress of the Republic endlessly debates this alarming chain of events,the Supreme Chancellor has secretly dispatched two Jedi Knights, the guardians of peace and justice in the galaxy, to settle the conflict....''';

  late final AnimationController _animationController;

  late Animation<Offset> crawlTextposition;

  late final Animation<double> disappearCrawlText;

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playTrack() async {
    await audioPlayer.play(
      AssetSource('audio/about_music.mp3'),
      volume: 0.03,
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    playTrack();
    disappearCrawlText = Tween<double>(begin: 1, end: 0)
        .chain(
          CurveTween(
            curve: const Interval(0.95, 1),
          ),
        )
        .animate(_animationController);
    _animationController.forward();
    _animationController.addStatusListener((AnimationStatus status) {
      log(status.toString());
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double topOffset =
        Sizescaleconfig.screenwidth! <= Sizescaleconfig.mobileBreakpoint
            ? height * 0.8
            : height / 1.5;
    final double bottomOffset = -height * 0.8;
    crawlTextposition =
        Tween(begin: Offset(0, topOffset), end: Offset(0, bottomOffset))
            .animate(_animationController);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: Image.asset(
                  'assets/galaxy.png',
                  fit: BoxFit.cover,
                  cacheHeight: 1294,
                  cacheWidth: 750,
                ),
              ),
            ),
            CrawlText(
              animationController: _animationController,
              crawlText: crawlText,
              crawlTextposition: crawlTextposition,
              disappearCrawlText: disappearCrawlText,
            ),
            Positioned(
              top: Sizescaleconfig.screenheight! * 0.02,
              child: const RepaintBoundary(child: BackButton()),
            ),
            // add mute button and vertical slider for volume in bottom right corner
            Positioned(
              bottom: kPaddingMediumConstant,
              right: 0,
              child: RepaintBoundary(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VolumeController(
                      audioController: audioPlayer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VolumeController extends StatefulWidget {
  const VolumeController({
    super.key,
    required this.audioController,
  });

  final AudioPlayer audioController;

  @override
  State<VolumeController> createState() => _VolumeControllerState();
}

class _VolumeControllerState extends State<VolumeController> {
  double _volume = 0.02;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RotatedBox(
          quarterTurns: -1,
          child: SizedBox(
            width: 200,
            height: 70,
            child: Platform.isAndroid
                ? Slider(
                    value: _volume,
                    activeColor: starWarsCrawlTextColor,
                    inactiveColor: Colors.white.withOpacity(0.5),
                    thumbColor: starWarsCrawlTextColor,
                    onChanged: (double volume) {
                      setState(() {
                        widget.audioController.setVolume(volume);
                        _volume = volume;
                      });
                    },
                  )
                : CupertinoSlider(
                    value: _volume,
                    activeColor: starWarsCrawlTextColor,
                    thumbColor: starWarsCrawlTextColor,
                    onChanged: (double volume) {
                      setState(() {
                        widget.audioController.setVolume(volume);
                        _volume = volume;
                      });
                    },
                  ),
          ),
        ),
        const SizedBox(
          height: kItemsSpacingExtraSmallConstant,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: starWarsCrawlTextColor,
          ),
          onPressed: () {
            setState(() {
              if (_volume == 0.0) {
                _volume = 0.02;
                widget.audioController.setVolume(_volume);
              } else {
                _volume = 0.0;
                widget.audioController.setVolume(_volume);
              }
            });
          },
          child: _volume == 0.0
              ? const Icon(Icons.volume_off)
              : const Icon(Icons.volume_up),
        ),
      ],
    );
  }
}

class CrawlText extends StatelessWidget {
  const CrawlText({
    super.key,
    required AnimationController animationController,
    required this.crawlText,
    required this.crawlTextposition,
    required this.disappearCrawlText,
  }) : _animationController = animationController;

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
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setRotationX(
              math.pi / 2.7, //2.8, //2.5,
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
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                offset: crawlTextposition.value,
                child: Opacity(
                  opacity: disappearCrawlText.value,
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CrawlContributions extends StatelessWidget {
  const CrawlContributions({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final TextStyle crawlBodyTextStyle = TextStyle(
      height: 1.3,
      fontSize: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
          ? Theme.of(context).textTheme.bodyLarge!.fontSize
          : Theme.of(context).textTheme.titleMedium!.fontSize,
      color: starWarsCrawlTextColor,
      fontFamily: 'Crawl',
    );

    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        final double maxdrag =
            details.primaryDelta! / Sizescaleconfig.screenheight!;

        final bool isScrolledDown = maxdrag.isNegative;

        final double animationValue = animationController.value;
        animationController
            .animateTo(
          isScrolledDown ? (animationValue + 0.1) : (animationValue - 0.1),
          duration: const Duration(milliseconds: 300),
        )
            .then((value) {
          if (!isScrolledDown) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        });
      },
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          // clipBehavior: Clip.none,
          // physics: NeverScrollableScrollPhysics(),
          children: [
            Text(
              'ChaseApp Development Credits',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.3,
                fontSize:
                    Sizescaleconfig.getDeviceType == DeviceType.SMALL_MOBILE
                        ? Theme.of(context).textTheme.titleMedium!.fontSize
                        : Theme.of(context).textTheme.headlineSmall!.fontSize,
                color: starWarsCrawlTextColor,
                fontFamily: 'Crawl',
              ),
            ),
            const Divider(
              height: kItemsSpacingMediumConstant,
              color: Colors.white,
              indent: kPaddingSmallConstant,
              endIndent: kPaddingSmallConstant,
              thickness: 1,
            ),
            Text(
              'A special thank you goes out to all those that have helped contribute code, ideas, and with the overall care and feeding of the system, we salute you.',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: crawlBodyTextStyle,
            ),
            const SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '# ',
                    style: crawlBodyTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Chases IRC team',
                    style: crawlBodyTextStyle.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 10,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '# ',
                    style: crawlBodyTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Chases Private Channel',
                    style: crawlBodyTextStyle.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 10,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kItemsSpacingMediumConstant,
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount:
                  Sizescaleconfig.getDeviceType == DeviceType.SMALL_MOBILE
                      ? 2
                      : Sizescaleconfig.getDeviceType == DeviceType.MOBILE
                          ? 2
                          : 3,
              mainAxisSpacing: kItemsSpacingSmallConstant,
              children: const [
                CustomAvatar(
                  name: 'Acidjazz',
                  link: 'https://github.com/acidjazz',
                ),
                CustomAvatar(
                  name: 'Jithatsonei',
                  link: 'https://github.com/jithatsonei',
                ),
                CustomAvatar(
                  name: 'Rutvik',
                  link: 'https://github.com/rutvik110',
                ),
                CustomAvatar(
                  name: 'Michael',
                  link: 'https://github.com/mfreeman451',
                ),
                CustomAvatar(
                  name: 'Cottongin',
                  link: 'https://github.com/cottongin',
                ),
                CustomAvatar(
                  name: 'Pilate',
                  link: 'https://github.com/pilate',
                ),
              ],
            ),
            const Divider(
              height: kItemsSpacingMediumConstant,
              color: Colors.white,
              thickness: 1,
              indent: kPaddingSmallConstant,
              endIndent: kPaddingSmallConstant,
            ),
            Text(
              'Thank You!',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
                    ? Theme.of(context).textTheme.titleMedium!.fontSize
                    : Theme.of(context).textTheme.headlineSmall!.fontSize,
                color: starWarsCrawlTextColor,
                fontFamily: 'Crawl',
              ),
            ),
            const SizedBox(
              height: kItemsSpacingMediumConstant,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.name,
    required this.link,
  });

  final String name;
  final String link;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: Sizescaleconfig.getDeviceType == DeviceType.SMALL_MOBILE
          ? Theme.of(context).textTheme.labelSmall!.fontSize
          : Theme.of(context).textTheme.labelLarge!.fontSize,
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
                avatar: const Icon(
                  Icons.link,
                  color: starWarsCrawlTextColor,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: starWarsCrawlTextColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5,
        ),
        child: Icon(
          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}
