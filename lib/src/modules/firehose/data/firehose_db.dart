// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// import '../../../const/app_bundle_info.dart';
// import '../../../models/notification/notification.dart';
// import '../../../models/youtube_data/youtube_data.dart';
// import 'firehose_db_ab.dart';

// class FirehoseNotificationsDatabase implements FirehoseNotificationsDbAB {
//   FirehoseNotificationsDatabase(this.notificationsCollectionRef);

//   final CollectionReference<ChaseAppNotification> notificationsCollectionRef;

//   // @override
//   // Future<List<ChaseAppNotification>> fetchNotifications(
//   //   ChaseAppNotification? notificationData,
//   // ) async {
//   //   final String? firehose = getStringFromInterestEnum(Interests.firehose);
//   //   if (notificationData == null) {
//   //     final QuerySnapshot<ChaseAppNotification> documentSnapshot =
//   //         await notificationsCollectionRef
//   //             // .where("uid", isEqualTo: userId)
//   //             .where('Interest', isEqualTo: firehose)
//   //             .orderBy('CreatedAt', descending: true)
//   //             .limit(20)
//   //             .get();
//   //     return documentSnapshot.docs
//   //         .map<ChaseAppNotification>(
//   //           (QueryDocumentSnapshot<ChaseAppNotification> snapshot) =>
//   //               snapshot.data(),
//   //         )
//   //         .toList();
//   //   } else {
//   //     final QuerySnapshot<ChaseAppNotification> documentSnapshot =
//   //         await notificationsCollectionRef
//   //             // .where("uid", isEqualTo: userId)
//   //             .where('Interest', isEqualTo: firehose)
//   //             .orderBy('createdAt', descending: true)
//   //             .startAfter([notificationData.createdAt])
//   //             .limit(20)
//   //             .get();

//   //     return documentSnapshot.docs
//   //         .map<ChaseAppNotification>(
//   //           (QueryDocumentSnapshot<ChaseAppNotification> snapshot) =>
//   //               snapshot.data(),
//   //         )
//   //         .toList();
//   //   }
//   // }

//   // @override
//   // Stream<List<ChaseAppNotification>> streamFirehoseNotifications() {
//   //   final Stream<QuerySnapshot<ChaseAppNotification>> snapshot =
//   //       notificationsCollectionRef
//   //           .where(
//   //             'Interest',
//   //             isEqualTo: getStringFromInterestEnum(Interests.firehose),
//   //           )
//   //           .orderBy('CreatedAt', descending: true)
//   //           .limit(5)
//   //           .snapshots();

//   //   return snapshot.map(
//   //     (QuerySnapshot<ChaseAppNotification> event) => event.docs
//   //         .map<ChaseAppNotification>(
//   //           (QueryDocumentSnapshot<ChaseAppNotification> e) => e.data(),
//   //         )
//   //         .toList(),
//   //   );
//   // }

//   // @override
//   // Future<TweetData> fetchTweetData(String tweetId) async {
//   //   final http.Response responce = await http.get(
//   //     Uri.parse(
//   //       'https://api.twitter.com/2/tweets?ids=$tweetId&expansions=author_id&user.fields=name,profile_image_url',
//   //     ),
//   //     headers: {
//   //       'Authorization': 'Bearer ${EnvVaribales.twitterToken}',
//   //     },
//   //   );
//   //   final Map<String, dynamic> result =
//   //       jsonDecode(responce.body) as Map<String, dynamic>;
//   //   final Map<String, dynamic> data = result['data'][0] as Map<String, dynamic>;
//   //   final Map<String, dynamic> user =
//   //       result['includes']['users'][0] as Map<String, dynamic>;

//   //   return TweetData(
//   //     tweetId: data['id'] as String,
//   //     text: data['text'] as String,
//   //     userId: data['author_id'] as String,
//   //     userName: user['username'] as String,
//   //     name: user['name'] as String,
//   //     profileImageUrl: user['profile_image_url'] as String,
//   //   );
//   // }

//   // @override
//   // Future<String> fetchTweetEmbedHtml(EmbedTweetParam param) async {
//   //   final http.Response responce = await http.get(
//   //     Uri.parse(
//   //       'https://publish.twitter.com/oembed?url=https://twitter.com/Interior/status/${param.tweetId}&hide_media=${param.showMedia}',
//   //     ),
//   //   );
//   //   final Map<String, dynamic> data =
//   //       jsonDecode(responce.body) as Map<String, dynamic>;
//   //   return data['html'] as String;
//   // }

//   @override
//   Future<YoutubeChannelData> fetchYoutubeChannelData(String channelId) async {
//     final http.Response responce = await http.get(
//       Uri.parse(
//         'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=$channelId&key=${EnvVaribales.youtubeApiKey}',
//       ),
//       headers: {
//         'Authorization': 'Bearer ${EnvVaribales.youtubeToken}',
//       },
//     );
//     final Map<String, dynamic> result =
//         jsonDecode(responce.body) as Map<String, dynamic>;
//     final Map<String, dynamic> data =
//         result['items'][0] as Map<String, dynamic>;

//     return YoutubeChannelData(
//       channelId: data['id'] as String,
//       name: data['snippet']['title'] as String,
//       imageUrl: data['snippet']['thumbnails']['default']['url'] as String,
//       subcribersCount: data['statistics']['subscriberCount'] as int,
//     );
//   }
// }
