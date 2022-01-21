import 'package:chaseapp/src/models/chase/chase.dart';

abstract class ChaseRepoAB {
  Stream<List<Chase>> streamChases();
  Stream<Chase> streamChase(String chaseId);
}
