import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void firebaseCloudMessaging_Listeners() {
  print('in fbCM_listeners');

  if (Platform.isIOS) iOS_Permission();

  _firebaseMessaging.getToken().then((token) {
    print(token);
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
}

void iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
}
