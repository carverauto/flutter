import 'dart:convert';

import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final firehoseNotificationsStreamProvider = StateNotifierProvider.family<
    PaginationNotifier<ChaseAppNotification>,
    PaginationNotifierState<ChaseAppNotification>,
    Logger>((ref, logger) {
  final user = ref.read(firebaseAuthProvider).currentUser!;

  return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        notification,
        offset,
      ) async {
        return ref.read(notificationRepoProvider).fetchNotifications(
              notification,
              "firehose-notifications",
              user.uid,
            );
      });
});

final fetchTweetEmbedData =
    FutureProvider.family<Map<String, dynamic>, String>((ref, tweetId) async {
  final responce = await http.get(
    Uri.parse(
        "https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/$tweetId"),
  );
  return jsonDecode(responce.body) as Map<String, dynamic>;
});
