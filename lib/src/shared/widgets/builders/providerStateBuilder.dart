import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../models/api_exception/api_exception.dart';
import '../errors/error_widget.dart';
import '../loaders/loading.dart';

class ChaseDetailsProviderStateBuilder<T> extends ConsumerWidget {
  const ChaseDetailsProviderStateBuilder({
    super.key,
    required this.builder,
    required this.watchThisProvider,
    required this.logger,
    this.errorMessage,
    this.errorBuilder,
    this.showBackButton = false,
    this.loadingBuilder,
    required this.chatsRow,
    required this.chatsView,
  });

  final ProviderBase<AsyncValue<T>> watchThisProvider;

  final Widget Function(
    T data,
    WidgetRef ref,
    Widget chatsRow,
    Widget chatsView,
  ) builder;
  final Widget Function(Object e, StackTrace? stk)? errorBuilder;

  final Logger logger;

  final String? errorMessage;
  final bool showBackButton;
  final Widget Function()? loadingBuilder;
  final Widget chatsRow;
  final Widget chatsView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisProvider).when(
          data: (data) {
            return builder(
              data,
              ref,
              chatsRow,
              chatsView,
            );
          },
          error: (Object e, StackTrace? stk) {
            logger.severe(
              errorMessage ?? 'Error Loading Data',
              e,
              stk,
            );
            return errorBuilder != null
                ? errorBuilder!(e, stk)
                : Material(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChaseAppErrorWidget(
                            onRefresh: () {
                              ref.refresh(watchThisProvider);
                            },
                          ),
                          if (showBackButton)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                        ],
                      ),
                    ),
                  );
          },
          loading: () => loadingBuilder != null
              ? loadingBuilder!()
              : const Material(
                  child: CircularAdaptiveProgressIndicatorWithBg(),
                ),
        );
  }
}

class ProviderStateBuilder<T> extends ConsumerWidget {
  const ProviderStateBuilder({
    super.key,
    required this.builder,
    required this.watchThisProvider,
    required this.logger,
    this.errorMessage,
    this.errorBuilder,
    this.showBackButton = false,
    this.loadingBuilder,
    this.child,
  });

  final ProviderBase<AsyncValue<T>> watchThisProvider;

  final Widget Function(T data, WidgetRef ref, Widget? child) builder;
  final Widget Function(ChaseAppCallException e, StackTrace? stk)? errorBuilder;

  final Logger logger;

  final String? errorMessage;
  final bool showBackButton;
  final Widget Function()? loadingBuilder;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisProvider).when(
          data: (data) {
            return builder(data, ref, child);
          },
          error: (Object e, StackTrace? stk) {
            final ChaseAppCallException chaseAppCallException =
                e is ChaseAppCallException
                    ? e
                    : ChaseAppCallException(
                        message: errorMessage ?? 'Unknown Error',
                        error: e,
                      );

            logger.severe(
              chaseAppCallException.message,
              chaseAppCallException.error ?? e,
              stk,
            );

            return errorBuilder != null
                ? errorBuilder!(chaseAppCallException, stk)
                : Material(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChaseAppErrorWidget(
                            onRefresh: () {
                              ref.refresh(watchThisProvider);
                            },
                          ),
                          if (showBackButton)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                        ],
                      ),
                    ),
                  );
          },
          loading: () => loadingBuilder != null
              ? loadingBuilder!()
              : const Material(
                  child: CircularAdaptiveProgressIndicatorWithBg(),
                ),
        );
  }
}

class SliverProviderStateBuilder<T> extends ConsumerWidget {
  const SliverProviderStateBuilder({
    super.key,
    required this.builder,
    required this.watchThisProvider,
    required this.logger,
    this.errorMessage,
    this.errorBuilder,
    this.loadingBuilder,
  });

  final ProviderBase<AsyncValue<T>> watchThisProvider;

  final Widget Function(T data) builder;
  final Widget Function(Object e, StackTrace? stk)? errorBuilder;

  final Logger logger;

  final String? errorMessage;
  final Widget Function()? loadingBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisProvider).when(
          data: builder,
          error: (Object e, StackTrace? stk) {
            logger.severe(
              errorMessage ?? 'Error Loading Data',
              e,
              stk,
            );
            return SliverToBoxAdapter(
              child: errorBuilder != null
                  ? errorBuilder!(e, stk)
                  : ChaseAppErrorWidget(
                      onRefresh: () {
                        ref.refresh(watchThisProvider);
                      },
                    ),
            );
          },
          loading: () => SliverToBoxAdapter(
            child: loadingBuilder != null
                ? loadingBuilder!()
                : const CircularAdaptiveProgressIndicatorWithBg(),
          ),
        );
  }
}
