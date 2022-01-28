import 'dart:developer';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderStateNotifierBuilder<T> extends ConsumerWidget {
  const ProviderStateNotifierBuilder({
    Key? key,
    required this.builder,
    this.watchThisProvider,
    this.watchThisStateNotifierProvider,
    this.scrollController,
  })  : assert(
            watchThisProvider == null || watchThisStateNotifierProvider == null,
            "One of them should be provided"),
        super(key: key);

  final ProviderBase<AsyncValue<T>>? watchThisProvider;

  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>>? watchThisStateNotifierProvider;

  final Widget Function(T data, ScrollController controller,
      [Widget bottomWidget]) builder;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (watchThisProvider != null) {
      return ref.watch(watchThisProvider!).when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    child:
                        builder(data, scrollController ?? ScrollController()),
                  ),
                  SizedBox(
                    height: kItemsSpacingLarge,
                  ),
                  CircularProgressIndicator(),
                ],
              );
            },
            error: (e, s) {
              log("Error Occured", error: e, stackTrace: s);
              return Text("Error : ${e.toString()}");
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
          );
    }

    return ref.watch(watchThisStateNotifierProvider!).when(
        data: (data, canLoad) {
      final isFetching =
          ref.read(watchThisStateNotifierProvider!.notifier).isFetching;
      final onGoingState =
          ref.read(watchThisStateNotifierProvider!.notifier).onGoingState;
      return builder(
        data as T,
        scrollController ?? ScrollController(),
        BottomWidget(
          isFetching: isFetching,
          onGoingState: onGoingState,
          watchThisStateNotifierProvider: watchThisStateNotifierProvider,
        ),
      );
    }, error: (e, s) {
      log("Error Occured", error: e, stackTrace: s);
      return Text("Error : ${e.toString()}");
    }, loading: (chases) {
      return Center(child: CircularProgressIndicator());
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
      PaginationNotifierState<Chase>>? watchThisStateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: BorderDirectional(
            top:
                BorderSide(color: Theme.of(context).colorScheme.primaryVariant),
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
          if (isFetching)
            Column(
              children: [
                CircularProgressIndicator.adaptive(),
              ],
            ),
          if (onGoingState == OnGoingState.Error)
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    ref
                        .read(watchThisStateNotifierProvider!.notifier)
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
