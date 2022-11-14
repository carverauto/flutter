import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../core/top_level_providers/services_providers.dart';

class ConnectivityStatus extends StatelessWidget {
  const ConnectivityStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final AsyncValue<bool> state = ref.watch(isConnectedStreamProvider);

        return state.maybeWhen(
          data: (bool isConnected) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: isConnected
                  ? const SizedBox.shrink()
                  : Chip(
                      padding: const EdgeInsets.all(kPaddingSmallConstant),
                      elevation: 2,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      avatar: Icon(
                        Icons.cloud_off,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      label: Text(
                        "You're Offline!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
            );
          },
          orElse: SizedBox.shrink,
        );
      },
    );
  }
}
