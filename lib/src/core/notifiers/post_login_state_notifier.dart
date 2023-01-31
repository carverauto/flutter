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
import '../../shared/util/helpers/request_permissions.dart';
import '../modules/auth/view/providers/providers.dart';
import '../top_level_providers/firebase_providers.dart';
import '../top_level_providers/services_providers.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this.ref,
  ) : super(const AsyncValue.data(null));

  final Ref ref;

  bool isInitialized = false;

  Logger logger = Logger('PostLoginStateNotifier');

  Future<void> initPostLoginActions() async {
    if (!isInitialized) {
      try {
        await ref.read(inAppPurchasesStateNotifier.notifier).initUser();
        final User user = ref.read(firebaseAuthProvider).currentUser!;
        final UserData userData = await ref.read(userStreamProvider.future);

        await _initFirebaseActions(user, userData);
        final bool isNotificationsPermissionGranted =
            await checkForPermissionsStatuses();

        if (isNotificationsPermissionGranted) {
          await checkUsersInterests();
        }

        isInitialized = true;
      } catch (e, stk) {
        logger.severe('Error initializing post login actions', e, stk);
      } finally {}
    }
  }

  Future<void> checkUsersInterests() async {
    try {
      final bool isPremiumMember =
          ref.read(inAppPurchasesStateNotifier.notifier).isPremiumMember;
      await PusherBeams.instance.start(EnvVaribales.instanceId);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final List<String?> usersInterests =
          await ref.read(pusherBeamsProvider).getDeviceInterests();
      final List<Interest> interests =
          await ref.read(notificationRepoProvider).fetchInterests();

      await Future.forEach<Interest>(interests, (Interest interest) async {
        if (interest.isPremium && !isPremiumMember) {
          return;
        }

        if (interest.isCompulsory) {
          if (!usersInterests.contains(interest.name)) {
            await ref
                .read(pusherBeamsProvider)
                .addDeviceInterest(interest.name);
            log('User subscribed to chases notifications from launch:');
          }
        } else if (interest.isDefault) {
          final bool wasAdded =
              ref.read(sharedPreferancesProvider).getBool(interest.name) ??
                  false;
          log('was added: $wasAdded');
          if (!wasAdded) {
            await ref
                .read(pusherBeamsProvider)
                .addDeviceInterest(interest.name);
            await ref
                .read(sharedPreferancesProvider)
                .setBool(interest.name, true);
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
    final String? token = await ref.read(firebaseMessagingProvider).getToken();

    if (token != null) {
      try {
        if (lastTokenUpdate != null && tokens != null) {
          final DateTime today = DateTime.now();
          final int difference = today.difference(lastTokenUpdate).inDays;
          final bool isTokenPresent =
              tokens.any((PushToken oldToken) => oldToken.token == token);

          if (difference > 7 || !isTokenPresent) {
            //update tokens
            await ref
                .read(authRepoProvider)
                .saveDeviceTokenToDatabase(user, token);
          }
          if (difference > 28 || !isTokenPresent) {
            await ref.read(authRepoProvider).subscribeToTopics();
          }
        } else {
          await ref
              .read(authRepoProvider)
              .saveDeviceTokenToDatabase(user, token);
          await ref.read(authRepoProvider).subscribeToTopics();
        }

        await ref
            .read(firebaseCrashlyticsProvider)
            .setUserIdentifier(userData.uid);
        ref.read(authRepoProvider).updateTokenWhenRefreshed(user);
      } catch (e, stk) {
        logger.warning('Error in initPostLogin Firebase Actions', e, stk);

        rethrow;
      }
    }
  }
}
