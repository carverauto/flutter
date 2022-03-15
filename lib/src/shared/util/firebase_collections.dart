import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

final CollectionReference chasesCollection = _firestore.collection('chases');
final CollectionReference usersCollection = _firestore.collection('users');
final CollectionReference notificationsCollection =
    _firestore.collection('notifications');
final CollectionReference interestsCollection =
    _firestore.collection('interests');

final CollectionReference animationsCollection =
    _firestore.collection('animations');

final CollectionReference<UserData> usersCollectionRef =
    usersCollection.withConverter<UserData>(
  fromFirestore: (data, _) {
    final rawData = data.data()!;

    if (rawData["tokens"] != null) {
      final tokens = rawData["tokens"] as List<dynamic>;
      if (tokens[0] is String) {
        rawData["tokens"] = null;
      }
    }

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

final notificationsCollectionRef =
    notificationsCollection.withConverter<ChaseAppNotification>(
  fromFirestore: (data, _) {
    final rawData = data.data()!;
    rawData["id"] = data.id;

    return ChaseAppNotification.fromJson(rawData);
  },
  toFirestore: (data, _) {
    return data.toJson();
  },
);
final interestsCollectionRef = interestsCollection.withConverter<Interest>(
  fromFirestore: (data, _) {
    final rawData = data.data()!;
    rawData["id"] = data.id;

    return Interest.fromJson(rawData);
  },
  toFirestore: (data, _) {
    return data.toJson();
  },
);
