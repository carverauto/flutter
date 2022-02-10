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
    this.errorMessage,
    this.errorBuilder,
  }) : super(key: key);

  final ProviderBase<AsyncValue<T>> watchThisProvider;

  final Widget Function(T data) builder;
  final Widget Function(Object e, StackTrace? stk)? errorBuilder;

  final Logger logger;

  final String? errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisProvider).when(
          data: (data) {
            return builder(data);
          },
          error: (e, stk) {
            logger.severe(
              errorMessage ?? 'Error Loading Data',
              e,
              stk,
            );
            return errorBuilder != null
                ? errorBuilder!(e, stk)
                : Scaffold(
                    body: ChaseAppErrorWidget(
                      onRefresh: () {
                        ref.refresh(watchThisProvider);
                      },
                    ),
                  );
          },
          loading: () => Scaffold(
            body: CircularAdaptiveProgressIndicatorWithBg(),
          ),
        );
  }
}
