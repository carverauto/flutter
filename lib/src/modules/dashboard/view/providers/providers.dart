import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';

final chasesPaginatedStreamProvider = StateNotifierProvider<
    PaginationNotifier<Chase>, PaginationNotifierState<Chase>>((ref) {
  return PaginationNotifier(
      hitsPerPage: 20,
      fetchNextItems: (
        chase,
        offset,
      ) {
        return ref.read(chaseRepoProvider).streamChases(chase, offset);
      });
});
