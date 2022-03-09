import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

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
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = axis == Axis.horizontal
          ? MediaQuery.of(context).size.width * 0.20
          : MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(watchThisStateNotifierProvider.notifier).fetchNextPage();
      }
    });
    return ref.watch(watchThisStateNotifierProvider).when(
      data: (data) {
        return builder(
          data,
          scrollController,
        );
      },
      error: (e, stk) {
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
      },
      loading: (chases) {
        return SliverToBoxAdapter(
          child: CircularAdaptiveProgressIndicatorWithBg(),
        );
      },
      onGoingLoading: (data) {
        return builder(
          data,
          scrollController,
        );
      },
      onGoingError: (data, error, stk) {
        return builder(
          data,
          scrollController,
        );
      },
    );
  }
}
