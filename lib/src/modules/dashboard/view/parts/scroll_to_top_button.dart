import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        double scrollOffset = scrollController.offset;
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: scrollOffset > Sizescaleconfig.screenheight! * 0.5
              ? FloatingActionButton(
                  tooltip: "Scroll to top",
                  child: Icon(
                    Icons.arrow_upward,
                  ),
                  onPressed: () async {
                    scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              : SizedBox.shrink(),
        );
      },
    );
  }
}
