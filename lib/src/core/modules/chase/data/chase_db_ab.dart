import 'package:chaseapp/src/models/chase/chase.dart';

abstract class ChaseDbAB {
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  );
  Stream<Chase> streamChase(String chaseId);
  Future<void> upVoteChase(String chaseId);
}
