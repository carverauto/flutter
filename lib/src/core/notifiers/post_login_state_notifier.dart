import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Logger logger = Logger("PostLoginStateNotifier");

  Future<void> initPostLoginActions(User user, UserData userData) async {
    if (!isInitialized) {
      try {
        await _initFirebaseActions(user, userData);

        await checkUsersInterests();

        isInitialized = true;
      } catch (e, stk) {
        logger.severe("Error initializing post login actions", e, stk);
      }
    }
  }

  Future<void> checkUsersInterests() async {
    try {
      if (F.appFlavor == Flavor.DEV) {
        const instanceId = String.fromEnvironment("Dev_Pusher_Instance_Id");
        await _read(pusherBeamsProvider).start(instanceId);
      } else {
        const instanceId = String.fromEnvironment("Prod_Pusher_Instance_Id");

        await _read(pusherBeamsProvider).start(instanceId);
      }
      final usersInterests =
          await _read(pusherBeamsProvider).getDeviceInterests();
      final interests = await _read(notificationRepoProvider).fetchInterests();

      await Future.forEach<Interest>(interests, (interest) async {
        if (interest.isCompulsory) {
          if (!usersInterests.contains(interest.name)) {
            await _read(pusherBeamsProvider).addDeviceInterest(interest.name);
          }
        }
      });
    } catch (e, stk) {
      logger.warning("Error checking users interests", e, stk);
      rethrow;
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

        rethrow;
      }
    }
  }
}

// List<Interest> activeInterests = [
//   Interest(name: "Chases", isCompulsory: true),
//   Interest(name: "firehose-notfiications", isCompulsory: false),
//   Interest(name: "world", isCompulsory: false),
// ];

// class Interest {
//   Interest({required this.name, required this.isCompulsory});
//   final String name;
//   final bool isCompulsory;
// }
