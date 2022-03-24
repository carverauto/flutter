// ignore_for_file: omit_local_variable_types

import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/notification/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db_ab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final FakeFirebaseFirestore fakeFirestore = FakeFirebaseFirestore();

final Provider<NotificationsDbAB> fakeNotificationsDbProvider =
    Provider<NotificationsDbAB>(
  (ProviderRef<NotificationsDbAB> ref) => NotificationsDatabase(
    notificationsCollectionRef: fakenotificationsCollectionRef,
    interestsCollectionRef: fakeinterestsCollectionRef,
  ),
);

final CollectionReference<ChaseAppNotification> fakenotificationsCollectionRef =
    fakeFirestore
        .collection('notifications')
        .withConverter<ChaseAppNotification>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;
    rawData['id'] = data.id;

    return ChaseAppNotification.fromJson(rawData);
  },
  toFirestore: (ChaseAppNotification data, _) {
    return data.toJson();
  },
);

final CollectionReference<Interest> fakeinterestsCollectionRef =
    fakeFirestore.collection('interests').withConverter<Interest>(
  fromFirestore: (DocumentSnapshot<Map<String, dynamic>> data, _) {
    final Map<String, dynamic> rawData = data.data()!;
    rawData['id'] = data.id;

    return Interest.fromJson(rawData);
  },
  toFirestore: (Interest data, _) {
    return data.toJson();
  },
);

void main() {
  late ChaseAppNotification notification;
  late List<ChaseAppNotification> notifications;
  late NotificationsDbAB notificationsDbAB;
  setUp(() async {
    final ProviderContainer container = ProviderContainer();
    notifications = List<ChaseAppNotification>.generate(20, (int index) {
      final DateTime createdAt = DateTime.now();

      return ChaseAppNotification(
        interest: 'firehose-notifications',
        id: '$index',
        type: 'twitter',
        title: '$index',
        body: '$index',
        createdAt: createdAt,
        data: const NotificationData(
          tweetData: TweetData(
            tweetId: '20',
            text: 'text',
            userId: 'userId',
            userName: 'userName',
            name: 'name',
            profileImageUrl: 'profileImageUrl',
          ),
        ),
      );
    });

    notification = notifications.first;

    await Future.forEach(notifications, (ChaseAppNotification element) async {
      await fakenotificationsCollectionRef.doc(element.id).set(
            element,
          );
    });

    notificationsDbAB = container.read(fakeNotificationsDbProvider);
  });
  //Failing with Unsupported package:fake_cloud_firestore/src/mock_query.
  test('fetchNotifications', () async {
    //context

    expect(
      await notificationsDbAB.fetchNotifications(null, null, 'userId'),
      isNotEmpty,
    );
  });
}
