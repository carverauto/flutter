import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../../modules/chats/view/providers/providers.dart';

class GetStreamTokenNotifier extends StateNotifier<void> {
  GetStreamTokenNotifier({
    required this.read,
  }) : super(null);

  final Reader read;

  final Logger logger = Logger('GetStreamUserTokenStateNotifier');

  late String userToken;
  late bool isTokenInitialized = false;

  Future<String> getUserToken(String uid) async {
    if (!isTokenInitialized) {
      userToken = await read(chatsRepoProvider).getUserToken(uid);

      isTokenInitialized = true;
    }

    return userToken;
  }
}
