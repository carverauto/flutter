import 'dart:developer';

import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  bool isInitialized = false;

  Future<void> initPostLoginActions(User user) async {
    if (!isInitialized) {
      //TODO: need to update the flow for requesting permissions
//requestPermissions();
      await _initFirebaseActions();
      isInitialized = true;
    }
  }

  Future<void> _initFirebaseActions() async {
    try {
      _read(authRepoProvider).saveFirebaseDeviceToken();
      _read(authRepoProvider).updateTokenWhenRefreshed();
      _read(authRepoProvider).subscribeToTopics();
    } catch (e) {
      log("Firebase Error --->", error: e);
    }
  }
}
