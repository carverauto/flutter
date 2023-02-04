import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../core/notifiers/pagination_notifier.dart';
import '../../../models/pagination_state/pagination_notifier_state.dart';
import '../errors/error_widget.dart';
import '../loaders/loading.dart';

class ProviderPaginatedStateNotifierBuilder<T> extends ConsumerWidget {
  const ProviderPaginatedStateNotifierBuilder({
    super.key,
    required this.builder,
    required this.watchThisStateNotifierProvider,
    required this.scrollController,
    required this.logger,
    this.loadingBuilder,
  });

  final AutoDisposeStateNotifierProvider<PaginationNotifier<T>,
      PaginationNotifierState<T>> watchThisStateNotifierProvider;

  final Widget Function(List<T> data, ScrollController controller) builder;

  final ScrollController scrollController;
  final Logger logger;

  final Widget Function()? loadingBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      final double maxScroll = scrollController.position.maxScrollExtent;
      final double currentScroll = scrollController.position.pixels;
      final double delta = MediaQuery.of(context).size.width * 0.20;
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

        return ChaseAppErrorWidget(
          onRefresh: () {
            ref
                .read(watchThisStateNotifierProvider.notifier)
                .fetchFirstPage(true);
          },
        );
      },
      loading: (List<T> chases) {
        return RepaintBoundary(
          child: loadingBuilder != null
              ? loadingBuilder!()
              : const CircularAdaptiveProgressIndicatorWithBg(),
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
