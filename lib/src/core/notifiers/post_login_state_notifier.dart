import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:pusher_beams/pusher_beams.dart';

import '../../const/app_bundle_info.dart';
import '../../models/interest/interest.dart';
import '../../models/push_tokens/push_token.dart';
import '../../models/user/user_data.dart';
import '../../modules/notifications/view/providers/providers.dart';
import '../modules/auth/view/providers/providers.dart';
import '../top_level_providers/firebase_providers.dart';
import '../top_level_providers/services_providers.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(const AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Logger logger = Logger('PostLoginStateNotifier');

  Future<void> initPostLoginActions(User user, UserData userData) async {
    if (!isInitialized) {
      try {
        await PusherBeams.instance.start(EnvVaribales.instanceId);
        await _initFirebaseActions(user, userData);

        await checkUsersInterests();

        isInitialized = true;
      } catch (e, stk) {
        logger.severe('Error initializing post login actions', e, stk);
      }
    }
  }

  Future<void> checkUsersInterests() async {
    try {
      final List<String?> usersInterests =
          await _read(pusherBeamsProvider).getDeviceInterests();
      final List<Interest> interests =
          await _read(notificationRepoProvider).fetchInterests();

      await Future.forEach<Interest>(interests, (Interest interest) async {
        if (interest.isCompulsory) {
          if (!usersInterests.contains(interest.name)) {
            await _read(pusherBeamsProvider).addDeviceInterest(interest.name);
          }
        } else if (interest.isDefault) {
          final bool wasAdded =
              _read(sharedPreferancesProvider).getBool(interest.name) ?? false;
          log('was added: $wasAdded');
          if (!wasAdded) {
            await _read(pusherBeamsProvider).addDeviceInterest(interest.name);
            await _read(sharedPreferancesProvider).setBool(interest.name, true);
          }
        }
      });
    } catch (e, stk) {
      logger.warning('Error checking users interests', e, stk);
      rethrow;
    }
  }

  Future<void> _initFirebaseActions(User user, UserData userData) async {
    final DateTime? lastTokenUpdate = userData.lastTokenUpdate;
    final List<PushToken>? tokens = userData.tokens;
    final String? token = await _read(firebaseMessagingProvider).getToken();

    if (token != null) {
      try {
        if (lastTokenUpdate != null && tokens != null) {
          final DateTime today = DateTime.now();
          final int difference = today.difference(lastTokenUpdate).inDays;
          final bool isTokenPresent =
              tokens.any((PushToken oldToken) => oldToken.token == token);

          if (difference > 7 || !isTokenPresent) {
            //update tokens
            await _read(authRepoProvider)
                .saveDeviceTokenToDatabase(user, token);
          }
          if (difference > 28 || !isTokenPresent) {
            await _read(authRepoProvider).subscribeToTopics();
          }
        } else {
          await _read(authRepoProvider).saveDeviceTokenToDatabase(user, token);
          await _read(authRepoProvider).subscribeToTopics();
        }

        await _read(firebaseCrashlyticsProvider)
            .setUserIdentifier(userData.uid);
        _read(authRepoProvider).updateTokenWhenRefreshed(user);
      } catch (e, stk) {
        logger.warning('Error in initPostLogin Firebase Actions', e, stk);

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
