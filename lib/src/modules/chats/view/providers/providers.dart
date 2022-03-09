import 'package:chaseapp/src/modules/chats/data/chats_db.dart';
import 'package:chaseapp/src/modules/chats/domain/chats_repo.dart';
import 'package:chaseapp/src/modules/chats/view/notifiers/chats_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  await ref.watch(watcherStateProvider(channel).future);

  return channel;
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
