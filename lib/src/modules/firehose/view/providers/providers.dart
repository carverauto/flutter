import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/youtube_data/youtube_data.dart';
import '../../../../shared/util/firebase_collections.dart';
import '../../data/firehose_db.dart';
import '../../data/firehose_db_ab.dart';
import '../../domain/firehose_repo.dart';
import '../../domain/firehose_repo_ab.dart';

final Provider<FirehoseNotificationsDbAB> firehoseDbProvider =
    Provider<FirehoseNotificationsDbAB>(
  (ProviderRef<FirehoseNotificationsDbAB> ref) => FirehoseNotificationsDatabase(
    notificationsCollectionRef,
  ),
);
final Provider<FirehoseRepoAB> firehoseRepoProvider = Provider<FirehoseRepoAB>(
  (ProviderRef<FirehoseRepoAB> ref) => FirehoseRepository(ref.read),
);

// final AutoDisposeStreamProvider<List<ChaseAppNotification>>
//     latestFirehoseNotificationsProvider =
//     StreamProvider.autoDispose<List<ChaseAppNotification>>(
//   (AutoDisposeStreamProviderRef<List<ChaseAppNotification>> ref) {
//     return ref.read(firehoseRepoProvider).streamFirehoseNotifications();
//   },
// );

// final AutoDisposeStateNotifierProviderFamily<
//         PaginationNotifier<ChaseAppNotification>,
//         PaginationNotifierState<ChaseAppNotification>,
//         Logger> firehoseNotificationsStreamProvider =
//     StateNotifierProvider.autoDispose.family<
//         PaginationNotifier<ChaseAppNotification>,
//         PaginationNotifierState<ChaseAppNotification>,
//         Logger>((
//   AutoDisposeStateNotifierProviderRef<PaginationNotifier<ChaseAppNotification>,
//           PaginationNotifierState<ChaseAppNotification>>
//       ref,
//   Logger logger,
// ) {
//   return PaginationNotifier(
//     hitsPerPage: 20,
//     logger: logger,
//     fetchNextItems: (
//       ChaseAppNotification? notification,
//       int offset,
//     ) async {
//       return ref.read(firehoseRepoProvider).fetchNotifications(
//             notification,
//           );
//     },
//   );
// });

// final FutureProviderFamily<String, EmbedTweetParam> fetchTweetEmbedData =
//     FutureProvider.family<String, EmbedTweetParam>(
//   (FutureProviderRef<String> ref, EmbedTweetParam param) async {
//     return ref.read(firehoseRepoProvider).fetchTweetEmbedHtml(param);
//   },
// );
// final FutureProviderFamily<TweetData, String> fetchTweetAlongUserData =
//     FutureProvider.family<TweetData, String>(
//   (FutureProviderRef<TweetData> ref, String tweetId) async {
//     return ref.read(firehoseRepoProvider).fetchTweetData(tweetId);
//   },
// );

final FutureProviderFamily<YoutubeChannelData, String>
    fetchYoutubeChannelDataProvider =
    FutureProvider.family<YoutubeChannelData, String>(
  (FutureProviderRef<YoutubeChannelData> ref, String channelId) async {
    return ref.read(firehoseRepoProvider).fetchYoutubeChannelData(channelId);
  },
);

class EmbedTweetParam {
  EmbedTweetParam({
    required this.tweetId,
    required this.showMedia,
  });
  final String tweetId;
  final bool showMedia;
}
