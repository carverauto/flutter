import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

class ChatStateNotifier extends StateNotifier<void> {
  ChatStateNotifier(this.read) : super(null);

  final Reader read;

  final Logger logger = Logger("ChatsServiceStateNotifier");

  final _client = stream.StreamChatClient(
    _getChatApiKey,
    logLevel: Level.INFO,
  );
  final feed.StreamFeedClient _streamFeedClient = feed.StreamFeedClient(
    _getChatApiKey,
  );
  static String get _getChatApiKey {
    if (F.appFlavor == Flavor.DEV) {
      const apiKey = String.fromEnvironment("Dev_GetStream_Chat_Api_Key");
      return apiKey;
    } else {
      const apiKey = String.fromEnvironment("Prod_GetStream_Chat_Api_Key");
      return apiKey;
    }
  }

  stream.StreamChatClient get client => _client;
  feed.StreamFeedClient get streamFeed => _streamFeedClient;

  Future<void> connectUserToGetStream(UserData userData) async {
    try {
      final userToken =
          await read(chatsRepoProvider).getUserToken(userData.uid);
      // final feed.Token userFeedToken =
      //     _streamFeedClient.frontendToken(userData.uid);
      await _streamFeedClient.setUser(
        feed.User(
          id: userData.uid,

          // name: userData.userName?.split(" ")[0] ?? "Unknown",
          // image: userData.photoURL,
        ),
        feed.Token(userToken),
      );

      if (client.wsConnectionStatus == stream.ConnectionStatus.disconnected)
        await client.connectUser(
          stream.User(
            id: userData.uid,
            name: userData.userName?.split(" ")[0] ?? "Unknown",
            image: userData.photoURL,
          ),
          userToken,
        );
    } catch (e, stk) {
      logger.severe("Error while connecting user to getStream", e, stk);
    }
  }

  Future<void> disconnectUser() async {
    try {
      await client.disconnectUser();
    } catch (e, stk) {
      logger.severe("Error while disconnecting user from getStream", e, stk);
    }
  }
}
