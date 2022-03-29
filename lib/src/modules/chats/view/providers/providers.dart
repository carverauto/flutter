import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../../flavors.dart';
import '../../../../const/app_bundle_info.dart';
import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../data/chats_db.dart';
import '../../domain/chats_repo.dart';
import '../notifiers/chats_notifier.dart';

typedef ChaseAppNotificationStateNotifierProvider
    = AutoDisposeStateNotifierProviderFamily<
        PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>,
        Logger>;

typedef ChaseAppNotificationStateNotifierProviderRef
    = AutoDisposeStateNotifierProviderRef<
        PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>>;

final Provider<ChatsRepository> chatsRepoProvider = Provider<ChatsRepository>(
  (ProviderRef<ChatsRepository> ref) => ChatsRepository(
    db: ChatsDatabase(ref.read),
  ),
);

final ProviderFamily<feed.StreamFeedClient, String> streamFeedClientProvider =
    Provider.family<feed.StreamFeedClient, String>(
        (ProviderRef<feed.StreamFeedClient> ref, String apiKey) {
  return feed.StreamFeedClient(apiKey, appId: '102359');
});

final StateNotifierProvider<ChatStateNotifier, void>
    chatsServiceStateNotifierProvider =
    StateNotifierProvider<ChatStateNotifier, void>(
  (StateNotifierProviderRef<ChatStateNotifier, void> ref) => ChatStateNotifier(
    read: ref.read,
    streamFeedClient: ref.read(
      streamFeedClientProvider(
        F.appFlavor == Flavor.DEV
            ? EnvVaribales.devGetStreamChatApiKey
            : EnvVaribales.prodGetStreamChatApiKey,
      ),
    ),
  ),
);

final AutoDisposeFutureProviderFamily<Channel, String> chatChannelProvider =
    FutureProvider.autoDispose.family<Channel, String>((
  AutoDisposeFutureProviderRef<Channel> ref,
  String chaseId,
) async {
  final StreamChatClient client =
      ref.read(chatsServiceStateNotifierProvider.notifier).client;
  final Channel channel = client.channel(
    'livestream',
    id: chaseId,
  );

  await channel.watch();

  return channel;
});

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
            .read(chatsServiceStateNotifierProvider.notifier)
            .fetchFirehoseFeed(offset);
      },
    );
  },
);

final AutoDisposeFutureProviderFamily<ChannelState, Channel>
    watcherStateProvider =
    FutureProvider.autoDispose.family<ChannelState, Channel>((
  AutoDisposeFutureProviderRef<ChannelState> ref,
  Channel channel,
) async {
  final ChannelState watchState = await channel.watch();

  ref.onDispose(() {
    channel.stopWatching();
  });

  return watchState;
});

final AutoDisposeStreamProvider<ConnectionStatus>
    chatWsConnectionStreamProvider =
    StreamProvider.autoDispose<ConnectionStatus>((
  AutoDisposeStreamProviderRef<ConnectionStatus> ref,
) {
  final StreamChatClient client =
      ref.read(chatsServiceStateNotifierProvider.notifier).client;

  return client.wsConnectionStatusStream;
});
