import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chase/chase.dart';
import '../../models/interest/interest.dart';
import '../../models/notification/notification.dart';
import '../../models/user/user_data.dart';
import '../../models/weather/weather.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference chasesCollection = _firestore.collection('chases');
final CollectionReference usersCollection = _firestore.collection('users');
final CollectionReference notificationsCollection =
    _firestore.collection('notifications');
final CollectionReference interestsCollection =
    _firestore.collection('interests');

final CollectionReference animationsCollection =
    _firestore.collection('animations');

final CollectionReference _stormSurgeAlertsCollection =
    _firestore.collection('weather');

final CollectionReference<UserData> usersCollectionRef =
    usersCollection.withConverter<UserData>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;

    if (rawData['tokens'] != null) {
      final List tokens = rawData['tokens'] as List<dynamic>;
      if (tokens[0] is String) {
        rawData['tokens'] = null;
      }
    }

    return UserData.fromJson(rawData);
  },
  toFirestore: (UserData data, _) {
    return data.toJson();
  },
);

final CollectionReference<Weather> stormSurgeAlertsRef =
    _stormSurgeAlertsCollection.withConverter<Weather>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;
    rawData['id'] = data.id;

    return Weather.fromJson(rawData);
  },
  toFirestore: (Weather data, _) {
    return data.toJson();
  },
);
final CollectionReference<Chase> chasesCollectionRef =
    chasesCollection.withConverter<Chase>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;
    rawData['id'] = data.id;

    return Chase.fromJson(rawData);
  },
  toFirestore: (Chase data, _) {
    return data.toJson();
  },
);

final CollectionReference<ChaseAppNotification> notificationsCollectionRef =
    notificationsCollection.withConverter<ChaseAppNotification>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;
    rawData['id'] = data.id;

    return ChaseAppNotification.fromJson(rawData);
  },
  toFirestore: (ChaseAppNotification data, _) {
    return data.toJson();
  },
);
final CollectionReference<Interest> interestsCollectionRef =
    interestsCollection.withConverter<Interest>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;
    rawData['id'] = data.id;

    return Interest.fromJson(rawData);
  },
  toFirestore: (Interest data, _) {
    return data.toJson();
  },
);
