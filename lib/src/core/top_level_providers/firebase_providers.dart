import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final AutoDisposeProvider<FirebaseAuth> firebaseAuthProvider =
    Provider.autoDispose<FirebaseAuth>(
        (AutoDisposeProviderRef<FirebaseAuth> ref) {
  return FirebaseAuth.instance;
});

final Provider<GoogleSignIn> googleSignInProvider =
    Provider<GoogleSignIn>((ProviderRef<GoogleSignIn> ref) => GoogleSignIn());
final Provider<FacebookAuth> facebookSignInProvider = Provider<FacebookAuth>(
  (ProviderRef<FacebookAuth> ref) => FacebookAuth.instance,
);

final Provider<FirebaseFunctions> functionsProvider =
    Provider<FirebaseFunctions>((ProviderRef<FirebaseFunctions> ref) {
  return FirebaseFunctions.instanceFor(region: 'us-central1');
});

final Provider<FirebaseStorage> storageProvider =
    Provider<FirebaseStorage>((ProviderRef<FirebaseStorage> ref) {
  return FirebaseStorage.instance;
});
final Provider<FirebaseAnalytics> analyticsProvider =
    Provider<FirebaseAnalytics>((ProviderRef<FirebaseAnalytics> ref) {
  return FirebaseAnalytics.instance;
});
final Provider<FirebaseAnalyticsObserver> analyticsoObserverProvider =
    Provider<FirebaseAnalyticsObserver>(
        (ProviderRef<FirebaseAnalyticsObserver> ref) {
  return FirebaseAnalyticsObserver(analytics: ref.watch(analyticsProvider));
});
final Provider<FirebaseMessaging> firebaseMessagingProvider =
    Provider<FirebaseMessaging>((ProviderRef<FirebaseMessaging> ref) {
  return FirebaseMessaging.instance;
});

final Provider<FirebaseFirestore> firestoreProvider =
    Provider<FirebaseFirestore>((ProviderRef<FirebaseFirestore> ref) {
  return FirebaseFirestore.instance;
});
final Provider<FirebaseRemoteConfig> firebaseRemoteConfigProvider =
    Provider<FirebaseRemoteConfig>(
  (ProviderRef<FirebaseRemoteConfig> ref) => FirebaseRemoteConfig.instance,
);
final Provider<FirebaseCrashlytics> firebaseCrashlyticsProvider =
    Provider<FirebaseCrashlytics>(
  (ProviderRef<FirebaseCrashlytics> ref) => FirebaseCrashlytics.instance,
);
