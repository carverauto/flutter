import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../../models/birds_of_fire/birds_of_fire.dart';

class BOFDB {
  Stream<List<BirdsOfFire>> getBofProperties() {
    final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
    final DatabaseReference bofRef = firebaseDatabase.child('bof');

    final Stream<List<BirdsOfFire>> maps =
        bofRef.onValue.map((DatabaseEvent event) {
      final List<BirdsOfFire> bofProperties = [];
      final String encodedData = jsonEncode(event.snapshot.value);

      final List<dynamic> bofList = jsonDecode(encodedData) as List<dynamic>;

      for (final bof in bofList) {
        final Map<String, dynamic> data = bof as Map<String, dynamic>;

        bofProperties.add(BirdsOfFire.fromJson(data));
      }
      return bofProperties;
    });

    return maps;
  }
}
