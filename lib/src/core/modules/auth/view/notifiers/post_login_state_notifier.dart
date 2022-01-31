import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Logger logger = Logger("PostLoginStateNotifier");

  Future<void> initPostLoginActions(UserData userData) async {
    if (!isInitialized) {
      await _initFirebaseActions(userData);
      isInitialized = true;
    }
  }

  Future<void> _initFirebaseActions(UserData userData) async {
    final lastTokenUpdate = userData.lastTokenUpdate;
    final tokens = userData.tokens;
    try {
      if (lastTokenUpdate != null && tokens != null) {
        final today = DateTime.now();
        final difference = today.difference(lastTokenUpdate).inDays;
        String? token = await _read(firebaseMesssagingProvider).getToken();
        final isTokenPresent = tokens.contains(token);
        if (difference > 7 || !isTokenPresent) {
          //update tokens
          _read(authRepoProvider).saveFirebaseDeviceToken();
        }
        if (difference > 28 || !isTokenPresent) {
          _read(authRepoProvider).subscribeToTopics();
        }
      } else {
        _read(authRepoProvider).saveFirebaseDeviceToken();
        _read(authRepoProvider).subscribeToTopics();
      }

      _read(firebaseCrashlyticsProvider).setUserIdentifier(userData.uid);
      _read(authRepoProvider).updateTokenWhenRefreshed();
    } catch (e, stk) {
      logger.warning("Error in initPostLogin Firebase Actions", e, stk);
    }
  }
}
