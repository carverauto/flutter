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

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topLeft.dy,
      left: topLeft.dx,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            topLeft += details.delta;
          });
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.5 * 9 / 16,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                //fit: StackFit.expand,
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
