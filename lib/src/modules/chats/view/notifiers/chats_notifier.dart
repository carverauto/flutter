import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

import '../../../../models/user/user_data.dart';
import '../providers/providers.dart';

class ChatStateNotifier extends StateNotifier<void> {
  ChatStateNotifier({
    required this.ref,
    required this.client,
  }) : super(null);

  final Ref ref;

  final Logger logger = Logger('ChatsServiceStateNotifier');

  final stream.StreamChatClient client;

  Future<void> connectUserToGetStream(UserData userData) async {
    try {
      final String userToken = await ref
          .read(getStreamUserTokenStateNotifierProvider.notifier)
          .getUserToken(userData.uid);

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
