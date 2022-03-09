import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final chasesPaginatedStreamProvider = StateNotifierProvider.autoDispose
    .family<PaginationNotifier<Chase>, PaginationNotifierState<Chase>, Logger>(
        (ref, logger) {
  return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        chase,
        offset,
      ) {
        return ref.read(chaseRepoProvider).streamChases(chase, offset);
      });
});

final topChasesStreamProvider = StreamProvider<List<Chase>>((ref) {
  return ref.read(chaseRepoProvider).streamTopChases();
});
