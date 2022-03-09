import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationsOverlayToggleSwitch extends StatelessWidget {
  const AnimationsOverlayToggleSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final bool showOverlay = ref.watch(showVideoOverlayProvider);

      return Switch.adaptive(
        value: showOverlay,
        onChanged: (value) {
          ref.read(showVideoOverlayProvider.state).update((state) => value);
        },
      );
    });
  }
}
