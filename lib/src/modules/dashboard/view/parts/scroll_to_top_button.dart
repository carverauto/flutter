import 'package:flutter/material.dart';

import '../../../../shared/util/helpers/sizescaleconfig.dart';

class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (BuildContext context, Widget? child) {
        final double scrollOffset = scrollController.offset;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: scrollOffset > Sizescaleconfig.screenheight! * 0.5
              ? FloatingActionButton(
                  tooltip: 'Scroll to top',
                  child: const Icon(
                    Icons.arrow_upward,
                  ),
                  onPressed: () async {
                    await scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
