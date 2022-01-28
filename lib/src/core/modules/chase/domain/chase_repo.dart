import 'package:chaseapp/src/core/modules/chase/domain/chase_repo_ab.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

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
  Stream<List<Chase>> streamChases() {
    return read(chaseDbProvider).streamChases();
  }

  @override
  Future<void> upVoteChase(String chaseId) {
    return read(chaseDbProvider).upVoteChase(chaseId);
  }
}
