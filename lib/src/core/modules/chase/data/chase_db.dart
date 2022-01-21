import 'package:chaseapp/src/core/modules/chase/data/chase_db_ab.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaseDatabase implements ChaseDbAB {
  ChaseDatabase({
    required this.read,
  });
  final Reader read;

  @override
  Stream<Chase> streamChase(String chaseId) {
    // TODO: implement streamChase
    return chasesCollectionRef
        .doc(chaseId)
        .snapshots()
        .map((chaseData) => chaseData.data()!);
  }

  @override
  Stream<List<Chase>> streamChases() {
    // TODO: implement streamChases
    return chasesCollectionRef
        .orderBy("CreatedAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
