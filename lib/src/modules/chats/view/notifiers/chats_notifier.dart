import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

import '../../../../core/top_level_providers/getstream_providers.dart';
import '../../../../models/user/user_data.dart';

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

  Future<void> connectUserToGetStream(UserData userData) async {
    try {
      if (!isTokenInitialized) {
        userToken = await read(fetchUserTokenForGetStream(userData.uid).future);
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
}
