import 'package:chaseapp/src/core/modules/chase/domain/chase_repo_ab.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // TODO: implement streamTopChases
    return read(chaseDbProvider).streamTopChases();
  }
}
