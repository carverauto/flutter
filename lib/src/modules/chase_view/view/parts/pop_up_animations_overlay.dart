import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PopupAnimationsView extends StatefulWidget {
  const PopupAnimationsView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final YoutubePlayerController controller;

  @override
  State<PopupAnimationsView> createState() => _PopupAnimationsViewState();
}

class _PopupAnimationsViewState extends State<PopupAnimationsView> {
  Widget animatingChild = Container(
    height: 50,
    width: 50,
    color: Colors.blue,
  );
  late PopUpAnimationMetaData popUpAnimationMetaData;
  Alignment prevAlignment = Alignment.center;
  Alignment nextAlignment = Alignment.center;
  Timer timer = Timer(Duration.zero, () {});
  bool isReady = false;

  late final StreamController<PopUpAnimationMetaData> streamController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(() {
      if (!isReady && widget.controller.value.isPlaying) {
        dev.log('Ready');
        Timer.periodic(const Duration(seconds: 4), (Timer timer) {
          final int index = Random().nextInt(9);
          streamController.add(
            popUpAnimationsList[index],
          );
        });
        setState(() {
          isReady = true;
        });
      }
    });
    streamController = StreamController<PopUpAnimationMetaData>();

    streamController.stream.listen((PopUpAnimationMetaData event) {
      setState(() {
        prevAlignment = nextAlignment;

        nextAlignment = event.alignment;
        animatingChild = Container(
          height: 100,
          width: 100,
          key: UniqueKey(),
          color: event.color,
        );
        timer.cancel();

        timer = Timer(const Duration(seconds: 3), () {
          setState(() {
            prevAlignment = nextAlignment;
            nextAlignment = nextAlignment;
            animatingChild = const SizedBox.shrink();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isReady
        ? const SizedBox.shrink()
        : AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            layoutBuilder: (Widget? child, List<Widget> childrens) {
              return Stack(
                children: [
                  Align(
                    alignment: nextAlignment,
                    child: child,
                  ),
                  Align(
                    alignment: prevAlignment,
                    child: childrens.isNotEmpty
                        ? childrens[0]
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            },
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: animatingChild,
          );
  }
}

class PopUpAnimationMetaData {
  PopUpAnimationMetaData({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;
}

List<PopUpAnimationMetaData> popUpAnimationsList = [
  PopUpAnimationMetaData(
    alignment: Alignment.topLeft,
    color: Colors.blue,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.topCenter,
    color: Colors.yellow,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.topRight,
    color: Colors.green,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.centerLeft,
    color: Colors.orange,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.center,
    color: Colors.white,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.centerRight,
    color: Colors.black,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.bottomLeft,
    color: Colors.grey,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.bottomCenter,
    color: Colors.purple,
  ),
  PopUpAnimationMetaData(
    alignment: Alignment.bottomRight,
    color: Colors.pink,
  ),
];
