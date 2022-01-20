//TODO: Add all firebase collections here with convertors and refer this
// declarations for using collections

import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

final CollectionReference<UserData> usersCollectionRef =
    _firestore.collection("users").withConverter<UserData>(
  fromFirestore: (data, _) {
    final rawData = data.data()!;

    return UserData.fromJson(rawData);
  },
  toFirestore: (data, _) {
    return data.toJson();
  },
);
