import 'dart:developer';

import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Future<void> initPostLoginActions() async {
    if (!isInitialized) {
      //TODO: need to update the flow for requesting permissions
//requestPermissions();
      await _initFirebaseActions();
      isInitialized = true;
    }
  }

  Future<void> _initFirebaseActions() async {
    final userData = await _read(userStreamProvider.future);
    final lastTokenUpdate = userData.lastTokenUpdate;
    final tokens = userData.tokens;
    try {
      if (lastTokenUpdate != null && tokens != null) {
        final today = DateTime.now();
        final difference = today.difference(lastTokenUpdate).inDays;
        String? token = await _read(firebaseMesssagingProvider).getToken();
        final isTokenPresent = tokens.contains(token);
        if (difference > 7 && !isTokenPresent) {
          //update tokens
          _read(authRepoProvider).saveFirebaseDeviceToken();
        }
        if (!isTokenPresent) {
          _read(authRepoProvider).subscribeToTopics();
        }
      } else {
        _read(authRepoProvider).saveFirebaseDeviceToken();
        _read(authRepoProvider).subscribeToTopics();
      }

      _read(firebaseCrashlyticsProvider).setUserIdentifier(userData.uid);
      _read(authRepoProvider).updateTokenWhenRefreshed();
    } catch (e) {
      log("Firebase Error --->", error: e);
    }
  }
}
