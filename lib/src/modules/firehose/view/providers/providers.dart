import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/models/youtube_data/youtube_data.dart';
import 'package:chaseapp/src/modules/firehose/data/firehose_db.dart';
import 'package:chaseapp/src/modules/firehose/data/firehose_db_ab.dart';
import 'package:chaseapp/src/modules/firehose/domain/firehose_repo.dart';
import 'package:chaseapp/src/modules/firehose/domain/firehose_repo_ab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    FutureProvider.family<String, EmbedTweetParam>((ref, param) async {
  return ref.read(firehoseRepoProvider).fetchTweetEmbedHtml(param);
});
final fetchTweetAlongUserData =
    FutureProvider.family<TweetData, String>((ref, tweetId) async {
  return ref.read(firehoseRepoProvider).fetchTweetData(tweetId);
});

final fetchYoutubeChannelDataProvider =
    FutureProvider.family<YoutubeChannelData, String>((ref, channelId) async {
  return ref.read(firehoseRepoProvider).fetchYoutubeChannelData(channelId);
});

class EmbedTweetParam {
  final String tweetId;
  final bool showMedia;
  EmbedTweetParam({required this.tweetId, required this.showMedia});
}
