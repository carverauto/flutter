import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/top_level_providers/services_providers.dart';
import 'view/likedtheapp_dialog.dart';

final StateNotifierProvider<AppReviewStateNotifier, AsyncValue<void>>
    appReviewStateNotifier =
    StateNotifierProvider<AppReviewStateNotifier, AsyncValue<void>>(
  (
    StateNotifierProviderRef<AppReviewStateNotifier, AsyncValue<void>> ref,
  ) {
    return AppReviewStateNotifier(
      ref: ref,
    );
  },
);

Future<bool?> showaskForReviewDialog(
  WidgetRef ref,
  BuildContext context,
) async {
  final bool? askReview = await showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LikedTheAppDialog();
    },
  );

  if (askReview != null && askReview) {
    await ref
        .read(
          appReviewStateNotifier.notifier,
        )
        .askForReview(context);
  }
  return null;
}

class AppReviewStateNotifier extends StateNotifier<AsyncValue<void>> {
  AppReviewStateNotifier({
    required this.ref,
  }) : super(const AsyncValue.loading());

  final Ref ref;

  Future<void> askForReview(BuildContext context) async {
    await resetCount();

    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await updateHasAskedForReview();
      await inAppReview.requestReview();
    }
  }

  bool get shouldShowAskForReviewDialog {
    if (isDoNotAskAgain) {
      return false;
    }
    if (hasAskedForReview) {
      return false;
    }
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    final int? chasesSeenCount = sharedPreferance.getInt('chases_seen');
    if (chasesSeenCount == null) {
      return false;
    }

    return chasesSeenCount >= 2;
  }

  Future<void> updatechasesSeenCount() async {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    final int? chasesSeenCount = sharedPreferance.getInt('chases_seen');
    await sharedPreferance.setInt('chases_seen', (chasesSeenCount ?? 0) + 1);
    await _updatechasesSeenInLifeTimeCount();
  }

  Future<int> _updatechasesSeenInLifeTimeCount() async {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    final int chasesSeenCount =
        (sharedPreferance.getInt('chases_seen_lifetime_count') ?? 0) + 1;
    await sharedPreferance.setInt(
      'chases_seen_lifetime_count',
      chasesSeenCount,
    );

    return chasesSeenCount;
  }

  bool get shouldShowPremiumDialog {
    final bool isPremiumMember =
        ref.read(inAppPurchasesStateNotifier.notifier).isPremiumMember;

    return getchasesSeenInLifeTimeCount == 5 && !isPremiumMember;
  }

  bool get shouldShowPremiumHeader {
    if (isChaseViewPremiumHeaderHidden) {
      return false;
    }
    final bool isPremiumMember =
        ref.read(inAppPurchasesStateNotifier.notifier).isPremiumMember;

    return getchasesSeenInLifeTimeCount >= 2 && !isPremiumMember;
  }

  bool get isChaseViewPremiumHeaderHidden {
    final bool? isHidden = ref.read(sharedPreferancesProvider).getBool(
          'hide_premium_chaseview_header',
        );

    return isHidden ?? false;
  }

  Future<void> hideChaseViewPremiumHeader() async {
    await ref.read(sharedPreferancesProvider).setBool(
          'hide_premium_chaseview_header',
          true,
        );
  }

  int get getchasesSeenInLifeTimeCount {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    final int chasesSeenCount =
        sharedPreferance.getInt('chases_seen_lifetime_count') ?? 0;

    return chasesSeenCount;
  }

  Future<void> resetCount() async {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    await sharedPreferance.setInt('chases_seen', 0);
  }

  bool get isReviewDialogShown {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);

    return sharedPreferance.getBool('isReviewDialogShown') ?? false;
  }

  bool get hasAskedForReview {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);

    return sharedPreferance.getBool('hasAskedForReview') ?? false;
  }

  // update hasAskedForReview to true
  Future<void> updateHasAskedForReview() async {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    await sharedPreferance.setBool('hasAskedForReview', true);
  }

  // get isDoNotAskAgainTurnedOn
  bool get isDoNotAskAgain {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    return sharedPreferance.getBool('isdoNotAskAgain') ?? false;
  }

  Future<void> updateDoNotAskAgain(bool value) async {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    await sharedPreferance.setBool('isdoNotAskAgain', value);
  }
  // firehose premium header

  int get getFirehoseViewCount {
    return ref.read(sharedPreferancesProvider).getInt('firehose_view_count') ??
        0;
  }

  // update firehose view count
  Future<int> updateFirehoseViewCount() async {
    final SharedPreferences sharedPreferance =
        ref.read(sharedPreferancesProvider);
    final int firehoseViewCount =
        (sharedPreferance.getInt('firehose_view_count') ?? 0) + 1;
    await sharedPreferance.setInt(
      'firehose_view_count',
      firehoseViewCount,
    );

    return firehoseViewCount;
  }

  bool get shouldShowFirehosePremiumHeader {
    if (isFirehosePremiumHeaderHidden) {
      return false;
    }

    final bool isPremiumMember =
        ref.read(inAppPurchasesStateNotifier.notifier).isPremiumMember;

    return !isPremiumMember;
    log(getFirehoseViewCount.toString());

    return getFirehoseViewCount > 2 && !isPremiumMember;
  }

  bool get isFirehosePremiumHeaderHidden {
    final bool? isHidden = ref.read(sharedPreferancesProvider).getBool(
          'hide_premium_firehose_header',
        );

    return isHidden ?? false;
  }

  Future<void> hideFirehosePremiumHeader() async {
    await ref.read(sharedPreferancesProvider).setBool(
          'hide_premium_firehose_header',
          true,
        );
  }
}
