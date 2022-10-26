// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../models/youtube_data/youtube_data.dart';
// import '../view/providers/providers.dart';
// import 'firehose_repo_ab.dart';

// class FirehoseRepository implements FirehoseRepoAB {
//   FirehoseRepository(this.read);

//   final Reader read;

//   // @override
//   // Future<List<ChaseAppNotification>> fetchNotifications(
//   //     ChaseAppNotification? notificationData) {
//   //   return read(firehoseDbProvider).fetchNotifications(notificationData);
//   // }

//   // @override
//   // Stream<List<ChaseAppNotification>> streamFirehoseNotifications() {
//   //   return read(firehoseDbProvider).streamFirehoseNotifications();
//   // }

//   // @override
//   // Future<TweetData> fetchTweetData(String tweetId) {
//   //   return read(firehoseDbProvider).fetchTweetData(tweetId);
//   // }

//   // @override
//   // Future<String> fetchTweetEmbedHtml(EmbedTweetParam tweetId) {
//   //   return read(firehoseDbProvider).fetchTweetEmbedHtml(tweetId);
//   // }

//   @override
//   Future<YoutubeChannelData> fetchYoutubeChannelData(String channelId) {
//     return read(firehoseDbProvider).fetchYoutubeChannelData(channelId);
//   }
// }
