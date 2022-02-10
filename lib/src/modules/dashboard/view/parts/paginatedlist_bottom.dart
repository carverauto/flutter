import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginatedListBottom extends StatelessWidget {
  const PaginatedListBottom({
    Key? key,
    required this.chasesPaingationProvider,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaingationProvider;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Consumer(
        builder: (context, ref, _) {
          return ref.watch(chasesPaingationProvider).maybeWhen(
                data: (chases, canLoad) {
                  final isFetching =
                      ref.read(chasesPaingationProvider.notifier).isFetching;
                  final onGoingState =
                      ref.read(chasesPaingationProvider.notifier).onGoingState;
                  return BottomWidget(
                    isFetching: isFetching,
                    onGoingState: onGoingState,
                    watchThisStateNotifierProvider: chasesPaingationProvider,
                  );
                },
                orElse: () => SizedBox.shrink(),
              );
        },
      ),
    );
  }
}
