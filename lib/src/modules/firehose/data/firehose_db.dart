import 'dart:convert';

import 'package:chaseapp/src/const/app_bundle_info.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/models/youtube_data/youtube_data.dart';
import 'package:chaseapp/src/modules/firehose/data/firehose_db_ab.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/interest_enum.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:chaseapp/src/shared/util/firebase_collections.dart';
import 'package:http/http.dart' as http;

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

  @override
  Future<TweetData> fetchTweetData(String tweetId) async {
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
  }

  @override
  Future<String> fetchTweetEmbedHtml(EmbedTweetParam param) async {
    final responce = await http.get(
      Uri.parse(
        "https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/${param.tweetId}&hide_media=${param.showMedia}",
      ),
    );
    final data = jsonDecode(responce.body) as Map<String, dynamic>;
    return data["html"] as String;
  }

  @override
  Future<YoutubeChannelData> fetchYoutubeChannelData(String channelId) async {
    final responce = await http.get(
      Uri.parse(
        "https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=$channelId&key=${EnvVaribales.youtubeApiKey}",
      ),
      headers: {
        "Authorization": "Bearer ${EnvVaribales.youtubeToken}",
      },
    );
    final result = jsonDecode(responce.body) as Map<String, dynamic>;
    final data = result["items"][0] as Map<String, dynamic>;

    return YoutubeChannelData(
      channelId: data["id"] as String,
      name: data["snippet"]["title"] as String,
      imageUrl: data["snippet"]["thumbnails"]["default"]["url"] as String,
      subcribersCount: data["statistics"]["subscriberCount"] as int,
    );
  }
}
