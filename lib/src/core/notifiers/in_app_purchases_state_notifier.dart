import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../const/app_bundle_info.dart';
import '../modules/auth/view/providers/providers.dart';
import '../top_level_providers/firebase_providers.dart';

class InAppPurchasesStateNotifier
    extends StateNotifier<AsyncValue<CustomerInfo>> {
  InAppPurchasesStateNotifier(
    this.ref,
  ) : super(const AsyncValue.loading());

  final Ref ref;

  bool isUserLoggedIn = false;
  late LogInResult logInResult;

  Logger logger = Logger('InAppPurchasesStateNotifier');

  bool get isPremiumMember =>
      state.value?.entitlements.all['Premium']?.isActive ?? false;

  void _updateCustomInfoStatus(CustomerInfo customerInfo) {
    state = AsyncValue.data(customerInfo);
  }

  void listenToAuthChanges() {
    ref.listen<AsyncValue<User?>>(
      streamLogInStatus,
      (AsyncValue<User?>? previous, AsyncValue<User?> next) async {
        final String? uid = next.value?.uid;
        if (previous?.value?.uid != uid && uid != null) {
          await initUser();
        }
        if (uid == null) {
          if (isUserLoggedIn) {
            isUserLoggedIn = false;
            final CustomerInfo customerInfo = await Purchases.logOut();
            state = AsyncValue.data(customerInfo);
            Purchases.removeCustomerInfoUpdateListener(_updateCustomInfoStatus);
          }
        }
      },
    );
  }

  Future<void> updateCustomerInfo() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      state = AsyncValue.data(customerInfo);
    } catch (e, stk) {
      state = AsyncValue.error(e, stackTrace: stk);
    }
  }

  Future<void> initUser() async {
    try {
      await _initPlatformState();
      listenToAuthChanges();

      Purchases.addCustomerInfoUpdateListener(_updateCustomInfoStatus);
      final String uid = ref.read(firebaseAuthProvider).currentUser!.uid;
      logInResult = await Purchases.logIn(uid);

      isUserLoggedIn = true;
      state = AsyncValue.data(logInResult.customerInfo);
    } catch (e, stk) {
      state = AsyncValue.error(e, stackTrace: stk);
      logger.severe('Error initializing revenue cat use', e, stk);
    }
  }

  //...

  Future<void> _initPlatformState() async {
    final String uid = ref.read(firebaseAuthProvider).currentUser!.uid;
    await Purchases.setDebugLogsEnabled(true);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration(EnvVaribales.revenueCat_Public_Google_SDK_Key);
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration(EnvVaribales.revenueCat_Public_Ios_SDK_Key);
    }
    await Purchases.configure(configuration..appUserID = uid);
  }
}
