import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/interest/interest.dart';
import '../../../models/notification/notification.dart';
import '../../../shared/util/firebase_collections.dart';
import 'notifications_db_ab.dart';

class NotificationsDatabase implements NotificationsDbAB {
  NotificationsDatabase();
  //TODO remove firehose notifications from the list
  @override
  Future<List<ChaseAppNotification>> fetchNotifications(
    ChaseAppNotification? notificationData,
    String? notificationType,
    String userId,
  ) async {
    if (notificationData == null) {
      final QuerySnapshot<ChaseAppNotification> documentSnapshot =
          await notificationsCollectionRef
              // .where("uid", isEqualTo: userId)
              .where('Interest', isEqualTo: notificationType)
              .orderBy('CreatedAt', descending: true)
              .limit(20)
              .get();
      return documentSnapshot.docs
          .map<ChaseAppNotification>(
            (QueryDocumentSnapshot<ChaseAppNotification> snapshot) =>
                snapshot.data(),
          )
          .toList();
    } else {
      final QuerySnapshot<ChaseAppNotification> documentSnapshot =
          await notificationsCollectionRef
              // .where("uid", isEqualTo: userId)
              .where('Interest', isEqualTo: notificationType)
              .orderBy('CreatedAt', descending: true)
              .startAfter([notificationData.createdAt])
              .limit(20)
              .get();
      return documentSnapshot.docs
          .map<ChaseAppNotification>(
            (QueryDocumentSnapshot<ChaseAppNotification> snapshot) =>
                snapshot.data(),
          )
          .toList();
    }
  }

  @override
  Future<List<Interest>> fetchInterests() async {
    final QuerySnapshot<Interest> documentSnapshots =
        await interestsCollectionRef.get();

    return documentSnapshots.docs
        .map((QueryDocumentSnapshot<Interest> doc) => doc.data())
        .toList();
  }
}
