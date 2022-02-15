import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Logger logger = Logger("PostLoginStateNotifier");

  Future<void> initPostLoginActions(User user, UserData userData) async {
    if (!isInitialized) {
      await _initFirebaseActions(user, userData);
      await connectToStream(user, userData);
      isInitialized = true;
    }
  }

  Future<void> connectToStream(User user, UserData userData) async {
    try {
      //TODO:generate token from server
      final userToken = await client.devToken(user.uid).rawValue;
      // final userToken =
      //     await _read(authRepoProvider).fetchUserStreamToken(user.uid);

      //TODO: Need to discuss?
      //Shouldn't this check be done within connectUser function instead?
      if (client.wsConnectionStatus != stream.ConnectionStatus.connected)
        await client.connectUser(
          stream.User(
              id: user.uid,
              name: userData.userName ?? "Unknown",
              image: userData.photoURL ?? defaultProfileURL),
          userToken,
        );
    } catch (e, stk) {
      logger.severe("Error while connecting user to getStream", e, stk);
    }
  }

  Future<void> _initFirebaseActions(User user, UserData userData) async {
    final lastTokenUpdate = userData.lastTokenUpdate;
    final tokens = userData.tokens;
    String? token = await _read(firebaseMesssagingProvider).getToken();

    if (token != null) {
      try {
        if (lastTokenUpdate != null && tokens != null) {
          final today = DateTime.now();
          final difference = today.difference(lastTokenUpdate).inDays;
          final isTokenPresent =
              tokens.any((oldToken) => oldToken.token == token);

          if (difference > 7 || !isTokenPresent) {
            //update tokens
            _read(authRepoProvider).saveDeviceTokenToDatabase(user, token);
          }
          if (difference > 28 || !isTokenPresent) {
            _read(authRepoProvider).subscribeToTopics();
          }
        } else {
          _read(authRepoProvider).saveDeviceTokenToDatabase(user, token);
          _read(authRepoProvider).subscribeToTopics();
        }

        _read(firebaseCrashlyticsProvider).setUserIdentifier(userData.uid);
        _read(authRepoProvider).updateTokenWhenRefreshed(user);
      } catch (e, stk) {
        logger.warning("Error in initPostLogin Firebase Actions", e, stk);
      }
    }
  }
}
