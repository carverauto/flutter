import 'package:chaseapp/src/models/chase/chase.dart';

abstract class ChaseDbAB {
  Stream<List<Chase>> streamChases();
  Stream<Chase> streamChase(String chaseId);
  Future<void> upVoteChase(String chaseId);
}
