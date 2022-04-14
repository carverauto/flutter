import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/chase/chase.dart';
import 'chase_db_ab.dart';

class ChaseDatabase implements ChaseDbAB {
  ChaseDatabase(this.chasesCollectionRef);

  final CollectionReference<Chase> chasesCollectionRef;
  @override
  Stream<Chase> streamChase(String chaseId) {
    return chasesCollectionRef
        .doc(chaseId)
        .snapshots()
        .map((DocumentSnapshot<Chase> chaseData) => chaseData.data()!);
  }

  @override
  Future<List<Chase>> streamChases(
    Chase? chase,
    int offset,
  ) async {
    if (chase == null) {
      final QuerySnapshot<Chase> documentSnapshot = await chasesCollectionRef
          .orderBy('CreatedAt', descending: true)
          .limit(20)
          .get();
      return documentSnapshot.docs
          .map((QueryDocumentSnapshot<Chase> snapshot) => snapshot.data())
          .toList();
    } else {
      final QuerySnapshot<Chase> documentSnapshot = await chasesCollectionRef
          .orderBy('CreatedAt', descending: true)
          .startAfter([chase.createdAt])
          .limit(20)
          .get();
      return documentSnapshot.docs
          .map((QueryDocumentSnapshot<Chase> snapshot) => snapshot.data())
          .toList();
    }
  }

  @override
  Future<void> upVoteChase(int upCount, String chaseId) async {
    final DocumentReference<Object?> chaseDocRef =
        chasesCollectionRef.doc(chaseId);

    await chaseDocRef.update({
      'Votes': FieldValue.increment(upCount),
    });
  }

  @override
  Stream<List<Chase>> streamTopChases() {
    return chasesCollectionRef
        .orderBy('CreatedAt', descending: true)
        .limit(3)
        .snapshots()
        .map((QuerySnapshot<Chase> snapshot) {
      return snapshot.docs
          .map<Chase>((QueryDocumentSnapshot<Chase> chase) => chase.data())
          .toList();
    });
  }
}
