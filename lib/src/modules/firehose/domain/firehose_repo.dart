import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/domain/firehose_repo_ab.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirehoseRepository implements FirehoseRepoAB {
  FirehoseRepository(this.read);

  final Reader read;

  @override
  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData) {
    return read(firehoseDbProvider).fetchNotifications(notificationData);
  }

  @override
  Stream<List<ChaseAppNotification>> streamFirehoseNotifications() {
    return read(firehoseDbProvider).streamFirehoseNotifications();
  }
}
