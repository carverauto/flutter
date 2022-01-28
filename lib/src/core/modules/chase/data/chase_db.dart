import 'package:chaseapp/src/core/modules/chase/data/chase_db_ab.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaseDatabase implements ChaseDbAB {
  ChaseDatabase();

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

  @override
  Future<void> upVoteChase(String chaseId) async {
    final chaseDocRef = chasesCollection.doc(chaseId);

    await chaseDocRef.update({
      'Votes': FieldValue.increment(1),
    });
  }
}
