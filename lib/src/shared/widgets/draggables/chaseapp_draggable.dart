import 'package:flutter/material.dart';

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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isMoved) {
      final double calculatedWidth =
          MediaQuery.of(context).size.width * (1 - 0.5);
      topLeft = Offset(
        calculatedWidth > 350
            ? MediaQuery.of(context).size.width - 350
            : calculatedWidth,
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topLeft.dy,
      left: topLeft.dx,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          isMoved = true;
          setState(() {
            topLeft += details.delta;
          });
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  widget.child,
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: widget.onExpandTap,
                      icon: const Icon(
                        Icons.fullscreen,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
