import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/chase/chase.dart';
import '../../../top_level_providers/services_providers.dart';
import 'chase_repo_ab.dart';

class ChaseRepository implements ChaseRepoAB {
  ChaseRepository({
    required this.read,
  });
  final Reader read;

  @override
  Stream<Chase> streamChase(String chaseId) {
    return read(chaseDbProvider).streamChase(chaseId);
  }

  @override
  Future<Chase> fetchChase(String chaseId) {
    return read(chaseDbProvider).fetchChase(chaseId);
  }

  @override
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  ) {
    return read(chaseDbProvider).streamChases(
      chase,
      offset,
    );
  }

  @override
  Future<void> upVoteChase(int upCount, String chaseId) {
    return read(chaseDbProvider).upVoteChase(upCount, chaseId);
  }

  @override
  Stream<List<Chase>> streamTopChases() {
    return read(chaseDbProvider).streamTopChases();
  }
}
