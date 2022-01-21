import 'dart:developer';

import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostLoginStateNotifier extends StateNotifier<AsyncValue<void>> {
  PostLoginStateNotifier(
    this._read,
  ) : super(AsyncValue.data(null));

  final Reader _read;

  Future<void> initPostLoginActions(User user) async {
    requestPermissions();
    _initFirebaseActions();
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
