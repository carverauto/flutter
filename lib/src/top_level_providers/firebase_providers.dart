import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

//Klaro
// final functionsProvider = Provider<FirebaseFunctions>((ref) {
//   return FirebaseFunctions.instanceFor(region: "us-central1");
// });

final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});
final firebaseMesssagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
// final firebaseRemoteConfigProvider =
//     Provider<RemoteConfig>((ref) => RemoteConfig.instance);
// final firebaseCrashlyticsProvider =
//     Provider<FirebaseCrashlytics>((ref) => FirebaseCrashlytics.instance);