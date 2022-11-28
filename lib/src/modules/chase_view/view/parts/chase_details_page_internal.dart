import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

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
            return orientation == Orientation.landscape
                ? Scaffold(
                    backgroundColor: Colors.black,
                    body: player,
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
                            child: ChaseDetails(
                              chase: chase,
                              imageURL: chase.imageURL,
                              logger: widget.logger,
                              chatsRow: widget.chatsRow,
                              chatsView: widget.chatsView,
                            ),
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
