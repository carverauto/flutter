import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      _flutterToast(message: message);
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      _flutterToast(message: message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      _flutterToast(message: message);
    },
  );
}

void _flutterToast({message}) {
  Fluttertoast.showToast(
      // msg: message.toString(),
      msg: 'We have a chase!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
}
