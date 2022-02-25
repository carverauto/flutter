import 'package:chaseapp/src/models/chase/chase.dart';
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
    FutureProvider.autoDispose.family<Channel, Chase>((ref, chase) async {
  final client = ref.read(chatsServiceStateNotifierProvider.notifier).client;
  final channel = client.channel(
    'livestream',
    id: chase.id,
    extraData: {
      'name': chase.name ?? "NA",
    },
  );
  await channel.watch();
  return channel;
});

final chatWsConnectionStreamProvider =
    StreamProvider.autoDispose<ConnectionStatus>((ref) {
  final client = ref.read(chatsServiceStateNotifierProvider.notifier).client;

  return client.wsConnectionStatusStream;
});