import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../../flavors.dart';
import '../../../../const/app_bundle_info.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../models/user/user_data.dart';
import '../../data/chats_db.dart';
import '../../domain/chats_repo.dart';
import '../notifiers/chats_notifier.dart';

final Provider<ChatsRepository> chatsRepoProvider = Provider<ChatsRepository>(
  (ProviderRef<ChatsRepository> ref) => ChatsRepository(
    db: ChatsDatabase(ref.read),
  ),
);

final Provider<feed.StreamFeedClient> streamFeedClientProvider =
    Provider<feed.StreamFeedClient>(
  (ProviderRef<feed.StreamFeedClient> ref) {
    return feed.StreamFeedClient(
      F.appFlavor == Flavor.DEV
          ? EnvVaribales.devGetStreamChatApiKey
          : EnvVaribales.prodGetStreamChatApiKey,
      appId: '102359',
    );
  },
);

final Provider<StreamChatClient> streamChatClientProvider =
    Provider<StreamChatClient>(
  (ProviderRef<StreamChatClient> ref) {
    final StreamChatClient client = StreamChatClient(
      F.appFlavor == Flavor.DEV
          ? EnvVaribales.devGetStreamChatApiKey
          : EnvVaribales.prodGetStreamChatApiKey,
      logLevel: Level.INFO,
    );

    return client;
  },
);

final StateNotifierProvider<ChatStateNotifier, void>
    chatsServiceStateNotifierProvider =
    StateNotifierProvider<ChatStateNotifier, void>(
  (
    StateNotifierProviderRef<ChatStateNotifier, void> ref,
  ) =>
      ChatStateNotifier(
    read: ref.read,
    // chaseId: chaseId,
    client: ref.watch(streamChatClientProvider),
  ),
);

final ProviderFamily<Channel, String> chatChannelProvider =
    Provider.family<Channel, String>((
  ProviderRef<Channel> ref,
  String chaseId,
) {
  //   final UserData userData =  ref.watch(userStreamProvider).asData!.value;

  //  ref
  //                 .read(chatsServiceStateNotifierProvider.notifier)
  //                 .connectUserToGetStream(userData);
  // await ref
  //     .watch(chatsServiceStateNotifierProvider.notifier)
  // //     .connectUserToGetStream(userData);
  // final StreamChatClient client =
  //     ref.watch(chatsServiceStateNotifierProvider(chaseId).notifier).client;
  final StreamChatClient client = ref.watch(streamChatClientProvider);
  final Channel channel = client.channel(
    'livestream',
    id: chaseId,
  );

  return channel;
});

final FutureProviderFamily<ChannelState, String> watcherStateProvider =
    FutureProvider.family<ChannelState, String>((
  FutureProviderRef<ChannelState> ref,
  String chaseId,
) async {
  final Channel channel = ref.watch(chatChannelProvider(chaseId));
  final ChannelState watchState = await channel.watch();

  return watchState;
});

final AutoDisposeStreamProvider<ConnectionStatus>
    chatWsConnectionStreamProvider =
    StreamProvider.autoDispose<ConnectionStatus>((
  AutoDisposeStreamProviderRef<ConnectionStatus> ref,
) async* {
  final UserData userData = await ref.watch(userStreamProvider.future);

  await ref
      .watch(chatsServiceStateNotifierProvider.notifier)
      .connectUserToGetStream(userData);
  final StreamChatClient client = ref.watch(streamChatClientProvider);

  yield* client.wsConnectionStatusStream;
});
