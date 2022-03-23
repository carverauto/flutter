import '../../../../models/chase/chase.dart';

abstract class ChaseDbAB {
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  );
  Stream<List<Chase>> streamTopChases();
  Stream<Chase> streamChase(String chaseId);
  Future<void> upVoteChase(int upCount, String chaseId);
}
