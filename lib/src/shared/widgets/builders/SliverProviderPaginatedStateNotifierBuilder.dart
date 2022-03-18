import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../core/notifiers/pagination_notifier.dart';
import '../../../models/pagination_state/pagination_notifier_state.dart';
import '../errors/error_widget.dart';
import '../loaders/loading.dart';

class SliverProviderPaginatedStateNotifierBuilder<T> extends ConsumerWidget {
  const SliverProviderPaginatedStateNotifierBuilder({
    Key? key,
    required this.builder,
    required this.watchThisStateNotifierProvider,
    required this.scrollController,
    required this.logger,
    required this.axis,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<PaginationNotifier<T>,
      PaginationNotifierState<T>> watchThisStateNotifierProvider;

  final Widget Function(List<T> data, ScrollController controller) builder;

  final ScrollController scrollController;
  final Logger logger;
  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      final double maxScroll = scrollController.position.maxScrollExtent;
      final double currentScroll = scrollController.position.pixels;
      final double delta = axis == Axis.horizontal
          ? MediaQuery.of(context).size.width * 0.20
          : MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(watchThisStateNotifierProvider.notifier).fetchNextPage();
      }
    });

    return ref.watch(watchThisStateNotifierProvider).when(
      data: (List<T> data) {
        return builder(
          data,
          scrollController,
        );
      },
      error: (Object? e, StackTrace? stk) {
        logger.log(Level.SEVERE, 'Error Fetching Data', e, stk);

        return SliverToBoxAdapter(
          child: ChaseAppErrorWidget(
            onRefresh: () {
              ref
                  .read(watchThisStateNotifierProvider.notifier)
                  .fetchFirstPage(true);
            },
          ),
        );
      },
      loading: (List<T> chases) {
        return const SliverToBoxAdapter(
          child:
              RepaintBoundary(child: CircularAdaptiveProgressIndicatorWithBg()),
        );
      },
      onGoingLoading: (List<T> data) {
        return builder(
          data,
          scrollController,
        );
      },
      onGoingError: (List<T> data, Object? error, StackTrace? stk) {
        return builder(
          data,
          scrollController,
        );
      },
    );
  }
}
