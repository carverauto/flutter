import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/models/youtube_data/youtube_data.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';

abstract class FirehoseRepoAB {
  Stream<List<ChaseAppNotification>> streamFirehoseNotifications();

  Future<List<ChaseAppNotification>> fetchNotifications(
      ChaseAppNotification? notificationData);

  Future<TweetData> fetchTweetData(String tweetId);
  Future<String> fetchTweetEmbedHtml(EmbedTweetParam tweetId);
  Future<YoutubeChannelData> fetchYoutubeChannelData(String channelId);
}
