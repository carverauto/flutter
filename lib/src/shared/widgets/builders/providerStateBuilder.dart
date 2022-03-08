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
    this.showBackButton = false,
    this.loadingBuilder,
  }) : super(key: key);

  final ProviderBase<AsyncValue<T>> watchThisProvider;

  final Widget Function(T data, WidgetRef ref) builder;
  final Widget Function(Object e, StackTrace? stk)? errorBuilder;

  final Logger logger;

  final String? errorMessage;
  final bool showBackButton;
  final Widget Function()? loadingBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisProvider).when(
        data: (data) {
          return builder(data, ref);
        },
        error: (e, stk) {
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
                            icon: Icon(Icons.arrow_back),
                            label: Text('Back'),
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
            : Material(
                child: CircularAdaptiveProgressIndicatorWithBg(),
              ));
  }
}

class SliverProviderStateBuilder<T> extends ConsumerWidget {
  const SliverProviderStateBuilder({
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
              child: CircularAdaptiveProgressIndicatorWithBg()),
        );
  }
}
