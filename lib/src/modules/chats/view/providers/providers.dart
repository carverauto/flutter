import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/chats/data/chats_db.dart';
import 'package:chaseapp/src/modules/chats/domain/chats_repo.dart';
import 'package:chaseapp/src/modules/chats/view/notifiers/chats_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

final chatsRepoProvider = Provider<ChatsRepository>(
  (ref) => ChatsRepository(
    db: ChatsDatabase(ref.read),
  ),
);

final chatsServiceStateNotifierProvider =
    StateNotifierProvider<ChatStateNotifier, void>(
        (ref) => ChatStateNotifier(ref.read));

final chatChannelProvider =
    FutureProvider.autoDispose.family<Channel, String>((ref, chaseId) async {
  final client = ref.read(chatsServiceStateNotifierProvider.notifier).client;
  final channel = client.channel(
    'livestream',
    id: chaseId,
  );

  await channel.watch();

  return channel;
});

final firehosePaginatedStateNotifierProvier = StateNotifierProvider.autoDispose
    .family<PaginationNotifier<feed.Activity>,
        PaginationNotifierState<feed.Activity>, Logger>((ref, logger) {
  return PaginationNotifier(
      hitsPerPage: 20,
      logger: logger,
      fetchNextItems: (
        notification,
        offset,
      ) async {
        return ref
            .read(chatsServiceStateNotifierProvider.notifier)
            .fetchFirehoseFeed(offset);
      });
});

final watcherStateProvider = FutureProvider.autoDispose
    .family<ChannelState, Channel>((ref, channel) async {
  final watchState = await channel.watch();

  ref.onDispose(() {
    channel.stopWatching();
  });

  return watchState;
});

final chatWsConnectionStreamProvider =
    StreamProvider.autoDispose<ConnectionStatus>((ref) {
  final client = ref.read(chatsServiceStateNotifierProvider.notifier).client;

  return client.wsConnectionStatusStream;
});
