import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ProviderStateNotifierBuilder<T> extends ConsumerWidget {
  const ProviderStateNotifierBuilder({
    Key? key,
    required this.builder,
    required this.watchThisStateNotifierProvider,
    required this.scrollController,
    required this.logger,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> watchThisStateNotifierProvider;

  final Widget Function(T data, ScrollController controller,
      [Widget bottomWidget]) builder;

  final ScrollController scrollController;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(watchThisStateNotifierProvider).when(
        data: (data, canLoad) {
      final isFetching =
          ref.read(watchThisStateNotifierProvider.notifier).isFetching;
      final onGoingState =
          ref.read(watchThisStateNotifierProvider.notifier).onGoingState;
      return builder(
        data as T,
        scrollController,
        BottomWidget(
          isFetching: isFetching,
          onGoingState: onGoingState,
          watchThisStateNotifierProvider: watchThisStateNotifierProvider,
        ),
      );
    }, error: (e, stk) {
      logger.log(Level.SEVERE, "Error Fetching Data", e, stk);
      return SliverToBoxAdapter(
        child: ChaseAppErrorWidget(
          onRefresh: () {
            ref
                .read(watchThisStateNotifierProvider.notifier)
                .fetchFirstPage(true);
          },
        ),
      );
    }, loading: (chases) {
      return SliverToBoxAdapter(
        child: CircularAdaptiveProgressIndicator(),
      );
    });
  }
}

class BottomWidget extends ConsumerWidget {
  const BottomWidget({
    Key? key,
    required this.isFetching,
    required this.onGoingState,
    required this.watchThisStateNotifierProvider,
  }) : super(key: key);

  final bool isFetching;
  final OnGoingState onGoingState;
  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> watchThisStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return onGoingState == OnGoingState.Data
        ? ref.watch(watchThisStateNotifierProvider.notifier).noMoreChases
            ? Chip(
                label: Text("No more Chases Found."),
              )
            : SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.all(15),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: BorderDirectional(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.primaryVariant),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  )
                ]),
            child: Column(
              children: [
                if (isFetching) CircularAdaptiveProgressIndicator(),
                if (onGoingState == OnGoingState.Error)
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(watchThisStateNotifierProvider.notifier)
                              .fetchNextPage();
                        },
                        icon: Icon(
                          Icons.replay,
                        ),
                      ),
                      Text("Something went wrong")
                    ],
                  ),
              ],
            ),
          );
  }
}
