import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../providers/providers.dart';
import 'chase_details.dart';
import 'chase_details_reactive_info.dart';

class ChaseDetailsInternal extends ConsumerStatefulWidget {
  const ChaseDetailsInternal({
    Key? key,
    required this.chase,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
    required this.logger,
    required this.chatsRow,
    required this.chatsView,
  }) : super(key: key);
  final Chase chase;
  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;
  final Logger logger;
  final Widget chatsRow;
  final Widget chatsView;

  @override
  ConsumerState<ChaseDetailsInternal> createState() =>
      _ChaseDetailsInternalState();
}

class _ChaseDetailsInternalState extends ConsumerState<ChaseDetailsInternal> {
  final bool expandChats = false;

  late final Animation<Offset> appBarOffsetAnimation;
  late final Animation<Offset> bottomListAnimation;
  late final Chase chase;
  GlobalKey playerKey = GlobalKey(debugLabel: 'Player');

  @override
  void initState() {
    super.initState();

    appBarOffsetAnimation = widget.appBarOffsetAnimation;
    bottomListAnimation = widget.bottomListAnimation;
    chase = widget.chase;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChaseHeroSectionBuilder player = ChaseHeroSectionBuilder(
      key: playerKey,
      chase: chase,
      imageUrl: chase.imageURL,
    );
    final ChaseDetails chaseDetails = ChaseDetails(
      chase: widget.chase,
      imageURL: widget.chase.imageURL,
      logger: widget.logger,
      chatsRow: widget.chatsRow,
      chatsView: widget.chatsView,
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (ref.read(isShowingChatsWindowProvide)) {
            ref
                .read(isShowingChatsWindowProvide.state)
                .update((bool state) => false);
            return false;
          }
          return true;
        },
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            log('TOP-->$orientation');
            //TODO: update later to show first view when in portrait mode but when its tablet or monitor mode(simply put when we have more than enough space to show both video,chat horizontally in portrait mode)

            return MediaQuery.of(context).orientation == Orientation.landscape
                ? Scaffold(
                    backgroundColor: Colors.black,
                    body: FullScreenChaseDetailsSideBar(
                      chase: chase,
                      chaseDetails: chaseDetails,
                      logger: widget.logger,
                      player: player,
                    ),
                  )
                : Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    body: AnimatedBuilder(
                      animation: bottomListAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.translate(
                          offset: bottomListAnimation.value,
                          child: child,
                        );
                      },
                      child: Column(
                        children: [
                          player,
                          Expanded(
                            child: chaseDetails,
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class FullScreenChaseDetailsSideBar extends StatefulWidget {
  const FullScreenChaseDetailsSideBar({
    Key? key,
    required this.chase,
    required this.logger,
    required this.chaseDetails,
    required this.player,
  }) : super(key: key);

  final Chase chase;
  final Logger logger;
  final Widget chaseDetails;
  final Widget player;

  @override
  State<FullScreenChaseDetailsSideBar> createState() =>
      _FullScreenChaseDetailsSideBarState();
}

class _FullScreenChaseDetailsSideBarState
    extends State<FullScreenChaseDetailsSideBar> {
  late bool isShowing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isShowing = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Row(
            children: [
              Expanded(child: widget.player),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width:
                      isShowing ? MediaQuery.of(context).size.width * 0.4 : 0,
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: isShowing ? 0 : -MediaQuery.of(context).size.width * 0.4,
            top: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isShowing ? 1.0 : 0.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: widget.chaseDetails,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 0,
            right: !isShowing ? 0 : MediaQuery.of(context).size.width * 0.4,
            child: Tooltip(
              message: isShowing ? 'Hide Chase Details' : 'Show Chase Details',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadiusLargeConstant),
                      bottomLeft: Radius.circular(kBorderRadiusLargeConstant),
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).focusScopeNode.unfocus();
                    isShowing = !isShowing;
                  });
                },
                child: isShowing
                    ? const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_left_rounded,
                        color: Colors.black,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
