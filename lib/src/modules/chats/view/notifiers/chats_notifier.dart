import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

import '../../../../models/user/user_data.dart';
import '../providers/providers.dart';

class ChatStateNotifier extends StateNotifier<void> {
  ChatStateNotifier({
    required this.read,
    // required this.chaseId,
    required this.client,
  }) : super(null);

  // final String chaseId;

  final Reader read;

  final Logger logger = Logger('ChatsServiceStateNotifier');

  late String userToken;
  late bool isTokenInitialized = false;

  final stream.StreamChatClient client;

  // // );

  // static String get _getChatApiKey {
  //   if (F.appFlavor == Flavor.DEV) {
  //     const String apiKey =
  //         String.fromEnvironment('Dev_GetStream_Chat_Api_Key');

  //     return apiKey;
  //   } else {
  //     const String apiKey =
  //         String.fromEnvironment('Prod_GetStream_Chat_Api_Key');

  //     return apiKey;
  //   }
  // }

  // stream.StreamChatClient get client => _client;

  // Future<stream.ChannelState> watchChannel() async {
  //   final stream.Channel channel = client.channel(
  //     'livestream',
  //     id: chaseId,
  //   );

  //   final stream.ChannelState channelState = await channel.watch();
  //   //  channelState.channel.type;

  //   return channelState;
  // }

  Future<void> connectUserToGetStream(UserData userData) async {
    try {
      if (!isTokenInitialized) {
        userToken = await read(chatsRepoProvider).getUserToken(userData.uid);
        isTokenInitialized = true;
      }

      if (client.wsConnectionStatus == stream.ConnectionStatus.disconnected) {
        await client.connectUser(
          stream.User(
            id: userData.uid,
            name: userData.userName?.split(' ')[0] ?? 'Unknown',
            image: userData.photoURL,
          ),
          userToken,
        );
      }
    } catch (e, stk) {
      logger.severe('Error while connecting user to getStream', e, stk);
    }
  }

  // Future<void> disconnectUser() async {
  //   try {
  //     await client.disconnectUser();
  //   } catch (e, stk) {
  //     logger.severe('Error while disconnecting user from getStream', e, stk);
  //   }
  // }
}
