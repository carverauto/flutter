import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityStatus extends StatelessWidget {
  const ConnectivityStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(isConnected);
      return state.maybeWhen(
        data: (isConnected) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: isConnected
                ? SizedBox.shrink()
                : Chip(
                    padding: EdgeInsets.all(kPaddingSmallConstant),
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
        orElse: () => SizedBox.shrink(),
      );
    });
  }
}
