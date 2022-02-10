import 'package:chaseapp/src/models/chase/chase.dart';

abstract class ChaseRepoAB {
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  );

  Stream<List<Chase>> streamTopChases();

  Stream<Chase> streamChase(String chaseId);
  Future<void> upVoteChase(int upCount, String chaseId);
}
