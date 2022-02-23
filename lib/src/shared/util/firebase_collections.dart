//TODO: Add all firebase collections here with convertors and refer this
// declarations for using collections

import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

final CollectionReference chasesCollection = _firestore.collection('chases');
final CollectionReference usersCollection = _firestore.collection('users');
// final CollectionReference notificationsCollection = _firestore.collection('users');

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

CollectionReference<NotificationData> notificationsCollectionRef(
    String userId) {
  final notificationsCollection = _firestore
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .withConverter<NotificationData>(
    fromFirestore: (data, _) {
      final rawData = data.data()!;
      rawData["id"] = data.id;

      return NotificationData.fromJson(rawData);
    },
    toFirestore: (data, _) {
      return data.toJson();
    },
  );

  return notificationsCollection;
}
