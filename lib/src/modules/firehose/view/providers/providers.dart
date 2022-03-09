import 'dart:convert';

import 'package:chaseapp/src/const/app_bundle_info.dart';
import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/modules/firehose/data/firehose_db.dart';
import 'package:chaseapp/src/modules/firehose/data/firehose_db_ab.dart';
import 'package:chaseapp/src/modules/firehose/domain/firehose_repo.dart';
import 'package:chaseapp/src/modules/firehose/domain/firehose_repo_ab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

final firehoseDbProvider = Provider<FirehoseNotificationsDbAB>(
    (ref) => FirehoseNotificationsDatabase());
final firehoseRepoProvider =
    Provider<FirehoseRepoAB>((ref) => FirehoseRepository(ref.read));

final latestFirehoseNotificationsProvider =
    StreamProvider.autoDispose<List<ChaseAppNotification>>((ref) {
  return ref.read(firehoseRepoProvider).streamFirehoseNotifications();
});

final firehoseNotificationsStreamProvider = StateNotifierProvider.autoDispose
    .family<PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>, Logger>((ref, logger) {
  return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        notification,
        offset,
      ) async {
        return ref.read(firehoseRepoProvider).fetchNotifications(
              notification,
            );
      });
});

final fetchTweetEmbedData =
    FutureProvider.family<Map<String, dynamic>, EmbedTweetParam>(
        (ref, param) async {
  final responce = await http.get(
    Uri.parse(
      "https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/${param.tweetId}&hide_media=${param.showMedia}",
    ),
  );
  return jsonDecode(responce.body) as Map<String, dynamic>;
});
final fetchTweetAlongUserData =
    FutureProvider.family<TweetData, String>((ref, tweetId) async {
  final responce = await http.get(
    Uri.parse(
      "https://api.twitter.com/2/tweets?ids=$tweetId&expansions=author_id&user.fields=name,profile_image_url",
    ),
    headers: {
      "Authorization": "Bearer ${EnvVaribales.twitterToken}",
    },
  );
  final result = jsonDecode(responce.body) as Map<String, dynamic>;
  final data = result["data"][0] as Map<String, dynamic>;
  final user = result["includes"]["users"][0] as Map<String, dynamic>;

  return TweetData(
    tweetId: data["id"] as String,
    text: data["text"] as String,
    userId: data["author_id"] as String,
    userName: user["username"] as String,
    name: user["name"] as String,
    profileImageUrl: user["profile_image_url"] as String,
  );
});

class EmbedTweetParam {
  final String tweetId;
  final bool showMedia;
  EmbedTweetParam({required this.tweetId, required this.showMedia});
}
