import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginatedListBottom<T> extends StatelessWidget {
  const PaginatedListBottom({
    Key? key,
    required this.chasesPaginationProvider,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<T>, PaginationNotifierState<T>>
      chasesPaginationProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return ref.watch(chasesPaginationProvider).maybeWhen(
              onGoingLoading: (data) {
                return CircularAdaptiveProgressIndicatorWithBg();
              },
              onGoingError: (data, error, stk) {
                return ChaseAppErrorWidget(onRefresh: () {
                  ref.read(chasesPaginationProvider.notifier).fetchNextPage();
                });
              },
              orElse: () => SizedBox.shrink(),
            );
      },
    );
  }
}
