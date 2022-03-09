import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/data/firehose_db_ab.dart';
import 'package:chaseapp/src/shared/enums/interest_enum.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';

class FirehoseNotificationsDatabase implements FirehoseNotificationsDbAB {
  FirehoseNotificationsDatabase();

  @override
  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData) async {
    final String firehose = getStringFromInterestEnum(Interests.firehose);
    if (notificationData == null) {
      final documentSnapshot = await notificationsCollectionRef
          // .where("uid", isEqualTo: userId)
          .where("Interest", isEqualTo: firehose)
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
          .where("Interest", isEqualTo: firehose)
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
  Stream<List<ChaseAppNotification>> streamFirehoseNotifications() {
    final snapshot = notificationsCollectionRef
        .where("Interest",
            isEqualTo: getStringFromInterestEnum(Interests.firehose))
        .orderBy("CreatedAt", descending: true)
        .limit(5)
        .snapshots();

    return snapshot.map((event) =>
        event.docs.map<ChaseAppNotification>((e) => e.data()).toList());
  }
}
