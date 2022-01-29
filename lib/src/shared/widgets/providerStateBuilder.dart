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
            return ErrorWidget(watchThisProvider: watchThisProvider);
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}

class ErrorWidget extends ConsumerWidget {
  const ErrorWidget({
    Key? key,
    required this.watchThisProvider,
  }) : super(key: key);

  final ProviderBase<AsyncValue> watchThisProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              ref.refresh(watchThisProvider);
            },
            icon: Icon(Icons.replay),
          ),
          //Chip doesn't show label properly with multiline text
          Chip(
            label: Text("Something went wrong."),
          ),
        ],
      ),
    );
  }
}
