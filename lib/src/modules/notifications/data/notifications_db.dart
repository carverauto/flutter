import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/notifications/data/notifications_db_ab.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';

class NotificationsDatabase implements NotificationsDbAB {
  NotificationsDatabase();

  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData,
      String? notificationType,
      String userId) async {
    if (notificationData == null) {
      final documentSnapshot = await notificationsCollectionRef
          // .where("uid", isEqualTo: userId)
          .where("Interest", isEqualTo: notificationType)
          .orderBy("CreatedAt", descending: true)
          .limit(20)
          .get();
      return documentSnapshot.docs
          .map<ChaseAppNotification>(
            (snapshot) => snapshot.data(),
          )
          .toList();
    } else {
      final documentSnapshot = await notificationsCollectionRef
          // .where("uid", isEqualTo: userId)
          .where("interest", isEqualTo: notificationType)
          .orderBy("createdAt", descending: true)
          .startAfter([notificationData.createdAt])
          .limit(20)
          .get();
      return documentSnapshot.docs
          .map<ChaseAppNotification>(
            (snapshot) => snapshot.data(),
          )
          .toList();
    }
  }

  @override
  Future<List<Interest>> fetchInterests() async {
    final documentSnapshots = await interestsCollectionRef.get();

    return documentSnapshots.docs.map((doc) => doc.data()).toList();
  }
}
