import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class AnimationsOverlayToggleSwitch extends StatelessWidget {
  const AnimationsOverlayToggleSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Toggle Animations Overlay',
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final bool showOverlay = ref.watch(showVideoOverlayProvider);

          return Switch(
            value: showOverlay,
            onChanged: (bool value) {
              ref
                  .read(showVideoOverlayProvider.state)
                  .update((bool state) => value);
            },
          );
        },
      ),
    );
  }
}
