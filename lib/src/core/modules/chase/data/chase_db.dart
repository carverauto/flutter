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
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  ) async {
    if (chase == null) {
      final documentSnapshot = await chasesCollectionRef
          .orderBy("CreatedAt", descending: true)
          .limit(20)
          .get();
      return documentSnapshot.docs.map((snapshot) => snapshot.data()).toList();
    } else {
      final documentSnapshot = await chasesCollectionRef
          .orderBy("CreatedAt", descending: true)
          .startAfter([chase.createdAt])
          .limit(20)
          .get();
      return documentSnapshot.docs.map((snapshot) => snapshot.data()).toList();
    }
  }

  @override
  Future<void> upVoteChase(String chaseId) async {
    final chaseDocRef = chasesCollection.doc(chaseId);

    await chaseDocRef.update({
      'Votes': FieldValue.increment(1),
    });
  }
}
