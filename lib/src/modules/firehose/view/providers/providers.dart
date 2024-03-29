import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/app_typedefs/notifications_typedefs.dart';
import '../../../chats/view/providers/providers.dart';
import '../notifiers/firehose_notifier.dart';

// final Provider<FirehoseNotificationsDbAB> firehoseDbProvider =
//     Provider<FirehoseNotificationsDbAB>(
//   (ProviderRef<FirehoseNotificationsDbAB> ref) => FirehoseNotificationsDatabase(
//     notificationsCollectionRef,
//   ),
// );
// final Provider<FirehoseRepoAB> firehoseRepoProvider = Provider<FirehoseRepoAB>(
//   (ProviderRef<FirehoseRepoAB> ref) => FirehoseRepository(ref.read),
// );

final StateNotifierProvider<FirehoseStateNotifier, void>
    firehoseServiceStateNotifierProvider =
    StateNotifierProvider<FirehoseStateNotifier, void>(
  (StateNotifierProviderRef<FirehoseStateNotifier, void> ref) =>
      FirehoseStateNotifier(
    ref: ref,
    streamFeedClient: ref.read(
      streamFeedClientProvider,
    ),
  ),
);

final ChaseAppNotificationStateNotifierProvider
    firehosePaginatedStateNotifierProvier = StateNotifierProvider.autoDispose
        .family<PaginationNotifier<ChaseAppNotification>,
            PaginationNotifierState<ChaseAppNotification>, Logger>(
  (
    ChaseAppNotificationStateNotifierProviderRef ref,
    Logger logger,
  ) {
    return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        ChaseAppNotification? notification,
        int offset,
      ) async {
        return ref
            .read(firehoseServiceStateNotifierProvider.notifier)
            .fetchFirehoseFeed(offset);
      },
    );
  },
);

// final FutureProviderFamily<YoutubeChannelData, String>
//     fetchYoutubeChannelDataProvider =
//     FutureProvider.family<YoutubeChannelData, String>(
//   (FutureProviderRef<YoutubeChannelData> ref, String channelId) async {
//     return ref.read(firehoseRepoProvider).fetchYoutubeChannelData(channelId);
//   },
// );

class EmbedTweetParam {
  EmbedTweetParam({
    required this.tweetId,
    required this.showMedia,
  });
  final String tweetId;
  final bool showMedia;
}
