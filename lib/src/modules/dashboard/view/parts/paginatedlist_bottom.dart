import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/widgets/errors/error_widget.dart';
import '../../../../shared/widgets/loaders/loading.dart';

class PaginatedListBottom<T> extends StatelessWidget {
  const PaginatedListBottom({
    super.key,
    required this.chasesPaginationProvider,
  });

  final AutoDisposeStateNotifierProvider<PaginationNotifier<T>,
      PaginationNotifierState<T>> chasesPaginationProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) {
        return ref.watch(chasesPaginationProvider).maybeWhen(
              onGoingLoading: (List<T> data) {
                return const CircularAdaptiveProgressIndicatorWithBg();
              },
              onGoingError: (List<T> data, Object? error, StackTrace? stk) {
                return ChaseAppErrorWidget(
                  onRefresh: () {
                    ref.read(chasesPaginationProvider.notifier).fetchNextPage();
                  },
                );
              },
              orElse: SizedBox.shrink,
            );
      },
    );
  }
}
