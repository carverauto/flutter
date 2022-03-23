import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';

final AutoDisposeStateNotifierProviderFamily<PaginationNotifier<Chase>,
        PaginationNotifierState<Chase>, Logger> chasesPaginatedStreamProvider =
    StateNotifierProvider.autoDispose.family<PaginationNotifier<Chase>,
        PaginationNotifierState<Chase>, Logger>((
  AutoDisposeStateNotifierProviderRef<PaginationNotifier<Chase>,
          PaginationNotifierState<Chase>>
      ref,
  Logger logger,
) {
  return PaginationNotifier(
    hitsPerPage: 20,
    logger: logger,
    fetchNextItems: (
      Chase? chase,
      int offset,
    ) {
      return ref.read(chaseRepoProvider).streamChases(chase, offset);
    },
  );
});

final StreamProvider<List<Chase>> topChasesStreamProvider =
    StreamProvider<List<Chase>>((StreamProviderRef<List<Chase>> ref) {
  return ref.read(chaseRepoProvider).streamTopChases();
});
