import 'dart:math';

import 'package:flutter/material.dart';

import '../../../const/sizings.dart';

class ChaseAppDraggableContainer extends StatefulWidget {
  const ChaseAppDraggableContainer({
    super.key,
    required this.child,
    required this.onExpandTap,
  });

  final Widget child;
  final Function() onExpandTap;

  @override
  State<ChaseAppDraggableContainer> createState() =>
      _ChaseAppDraggableContainerState();
}

class _ChaseAppDraggableContainerState
    extends State<ChaseAppDraggableContainer> {
  Offset topLeft = const Offset(0, 0);
  bool isMoved = false;
  late double width;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isMoved) {
      width = MediaQuery.of(context).size.width * 0.5;
      final double calculatedWidth =
          MediaQuery.of(context).size.width * (1 - 0.5);
      topLeft = const Offset(
        0,
        // calculatedWidth > 350
        //     ? MediaQuery.of(context).size.width - 350
        //     : calculatedWidth,
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topLeft.dy,
      left: topLeft.dx,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                isMoved = true;
                setState(() {
                  topLeft += details.delta;
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
              minWidth: 150,
            ),
            child: SizedBox(
              width: width,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(kBorderRadiusLargeConstant),
                    clipBehavior: Clip.hardEdge,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails drag) {
                final bool isIncreasing = drag.delta.direction.isNegative;
                setState(() {
                  width += drag.delta.dx;
                  print(isIncreasing);
                });
              },
              child: Transform.rotate(
                angle: pi / 2,
                child: const Icon(
                  Icons.open_in_full,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
