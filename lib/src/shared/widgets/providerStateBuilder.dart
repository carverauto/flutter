import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ProviderStateBuilder<T> extends ConsumerWidget {
  const ProviderStateBuilder({
    Key? key,
    required this.builder,
    required this.watchThisProvider,
    required this.logger,
  }) : super(key: key);

  final ProviderBase<AsyncValue<T>> watchThisProvider;

  final Widget Function(T data) builder;

  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisProvider).when(
          data: (data) {
            return builder(data);
          },
          error: (e, stk) {
            logger.severe(
              'Error Loading Data',
              e,
              stk,
            );
            return ChaseAppErrorWidget(
              onRefresh: () {
                ref.refresh(watchThisProvider);
              },
            );
          },
          loading: () => CircularAdaptiveProgressIndicator(),
        );
  }
}
