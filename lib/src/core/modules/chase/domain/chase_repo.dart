import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/chase/chase.dart';
import '../../../top_level_providers/services_providers.dart';
import 'chase_repo_ab.dart';

class ChaseRepository implements ChaseRepoAB {
  ChaseRepository({
    required this.ref,
  });
  final Ref ref;

  @override
  Stream<Chase> streamChase(String chaseId) {
    return ref.read(chaseDbProvider).streamChase(chaseId);
  }

  @override
  Future<Chase> fetchChase(String chaseId) {
    return ref.read(chaseDbProvider).fetchChase(chaseId);
  }

  @override
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  ) {
    return ref.read(chaseDbProvider).streamChases(
          chase,
          offset,
        );
  }

  @override
  Future<void> upVoteChase(int upCount, String chaseId) {
    return ref.read(chaseDbProvider).upVoteChase(upCount, chaseId);
  }

  @override
  Stream<List<Chase>> streamTopChases() {
    return ref.read(chaseDbProvider).streamTopChases();
  }
}
