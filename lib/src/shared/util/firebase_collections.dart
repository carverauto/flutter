//TODO: Add all firebase collections here with convertors and refer this
// declarations for using collections

import 'dart:developer';

import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

final CollectionReference chasesCollection = _firestore.collection('chases');
final CollectionReference usersCollection = _firestore.collection('users');

final CollectionReference<UserData> usersCollectionRef =
    usersCollection.withConverter<UserData>(
  fromFirestore: (data, _) {
    final rawData = data.data()!;

    return UserData.fromJson(rawData);
  },
  toFirestore: (data, _) {
    return data.toJson();
  },
);

final CollectionReference<Chase> chasesCollectionRef =
    chasesCollection.withConverter<Chase>(
  fromFirestore: (data, _) {
    final rawData = data.data()!;
    rawData["id"] = data.id;

    return Chase.fromJson(rawData);
  },
  toFirestore: (data, _) {
    return data.toJson();
  },
);
