// ignore_for_file: omit_local_variable_types

import 'package:chaseapp/src/core/modules/chase/data/chase_db.dart';
import 'package:chaseapp/src/core/modules/chase/data/chase_db_ab.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //arrange
  final FakeFirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
  late final CollectionReference<Chase> fakeChasesCollectionRef;
  late final ChaseDbAB chaseDb;
  late final Chase chase;
  late final List<Chase> chases;
  setUpAll(() async {
    chases = List<Chase>.generate(20, (int index) {
      final DateTime createdAt = DateTime.now();
      print(createdAt.millisecondsSinceEpoch);
      return Chase(
        id: '$index',
        name: 'Temple chase',
        live: true,
        createdAt: createdAt,
        desc: 'desc',
        votes: 100 + index,
      );
    });

    fakeChasesCollectionRef =
        fakeFirestore.collection('chases').withConverter<Chase>(
      fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
        final Map<String, dynamic> rawData = data.data()!;
        rawData['id'] = data.id;

        return Chase.fromJson(rawData);
      },
      toFirestore: (Chase data, _) {
        return data.toJson();
      },
    );
    chase = chases.first;

    await Future.forEach(chases, (Chase element) async {
      await fakeChasesCollectionRef.doc(element.id).set(
            element,
          );
    });

    chaseDb = ChaseDatabase(fakeChasesCollectionRef);
  });

  test('streamChase', () async {
    //context

    expect(
      chaseDb.streamChase('0'),
      emitsInOrder(<Chase>[
        chase,
      ]),
    );
  });

  test('streamChases at offset 0', () async {
    final List<Chase> chases = await chaseDb.streamChases(null, 0);
    expect(chases, isNotEmpty);
    expect(chases, isNotNull);
    expect(chases, hasLength(20));
  });

  //TODO:Failing need to come back to this later!
  test('streamChases at offset 50', () async {
    final List<Chase> chasesList = await chaseDb.streamChases(chases[0], 50);
    expect(chasesList, isNotEmpty);
    expect(chasesList, isNotNull);
    expect(chasesList.length <= 20, isTrue);
  });
  test('Upvote a chase', () async {
    const int index = 0; //should be within range of chases list
    final int originalCount = chases[index].votes ?? 0;
    const int upVoteCount = 25;
    await chaseDb.upVoteChase(upVoteCount, index.toString());
    final DocumentSnapshot<Chase> chaseDoc =
        await fakeChasesCollectionRef.doc(index.toString()).get();
    final Chase? chase = chaseDoc.data();

    expect(chase?.votes, originalCount + upVoteCount);
  });

  test('Stream Top Chases', () async {
    //arrange
    //act
    final Stream<List<Chase>> snapshot = chaseDb.streamTopChases();
    final List<Chase> topChases = await snapshot.first;

    //assert
    expect(topChases, isNotEmpty);
    expect(topChases, isNotNull);
    expect(
      topChases,
      chases.sublist(chases.length - 3, chases.length).reversed.toList(),
    );
  });
}
