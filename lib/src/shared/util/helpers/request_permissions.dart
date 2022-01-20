import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  const btScanStatus = Permission.bluetoothScan;
  const btConnectStatus = Permission.bluetoothConnect;
  const btServiceStatus = Permission.bluetooth;
  const locationAlwaysStatus = Permission.locationAlways;
  const locationStatus = Permission.location;
  const notifyStatus = Permission.notification;

  bool isBtOn = btServiceStatus == btServiceStatus.isGranted;
  bool isBtScanOn = btScanStatus == btScanStatus.isGranted;
  bool isBtConnectOn = btConnectStatus == btConnectStatus.isGranted;
  bool isLocationOn = locationStatus == locationStatus.isGranted;
  bool isLocationAlwaysOn =
      locationAlwaysStatus == locationAlwaysStatus.isGranted;
  bool isNotifyOn = notifyStatus == notifyStatus.isGranted;

  final permBtServiceStatus = await Permission.bluetooth.request();
  final permBtScanStatus = await Permission.bluetoothScan.request();
  final permBtConnectStatus = await Permission.bluetoothConnect.request();
  final permLocationStatus = await Permission.location.request();
  final permLocationAlwaysStatus = await Permission.locationAlways.request();
  final permNotifyStatus = await Permission.notification.request();

  if (permBtServiceStatus == PermissionStatus.granted) {
    if (kDebugMode) {
      print('BTServiceStatus - Permission Granted');
    }
  } else if (permBtServiceStatus == PermissionStatus.denied) {
    if (kDebugMode) {
      print('BTServiceStatus - Permission Denied');
    }
  } else if (permBtServiceStatus == PermissionStatus.permanentlyDenied) {
    if (kDebugMode) {
      print('BTServiceStatus - Permission Permanently Denied');
    }
    await openAppSettings();
  }

  if (permBtScanStatus == PermissionStatus.granted) {
    if (kDebugMode) {
      print('BTScanStatus - Permission Granted');
    }
  } else if (permBtScanStatus == PermissionStatus.denied) {
    if (kDebugMode) {
      print('BTScanStatus - Permission Denied');
    }
  } else if (permBtScanStatus == PermissionStatus.permanentlyDenied) {
    if (kDebugMode) {
      print('BTScanStatus - Permission Permanently Denied');
    }
    await openAppSettings();
  }

  if (permBtConnectStatus == PermissionStatus.granted) {
    if (kDebugMode) {
      print('BTConnectStatus - Permission Granted');
    }
  } else if (permBtConnectStatus == PermissionStatus.denied) {
    if (kDebugMode) {
      print('BTConnectStatus - Permission Denied');
    }
  } else if (permBtConnectStatus == PermissionStatus.permanentlyDenied) {
    if (kDebugMode) {
      print('BTConnectStatus - Permission Permanently Denied');
    }
    await openAppSettings();
  }

  if (permLocationAlwaysStatus == PermissionStatus.granted) {
    if (kDebugMode) {
      print('LocationAlways - Permission Granted');
    }
  } else if (permLocationAlwaysStatus == PermissionStatus.denied) {
    if (kDebugMode) {
      print('LocationAlways - Permission Denied');
    }
  } else if (permLocationAlwaysStatus == PermissionStatus.permanentlyDenied) {
    if (kDebugMode) {
      print('LocationAlways - Permission Permanently Denied');
    }
    await openAppSettings();
  }

  if (permLocationStatus == PermissionStatus.granted) {
    if (kDebugMode) {
      print('Location - Permission Granted');
    }
  } else if (permLocationStatus == PermissionStatus.denied) {
    if (kDebugMode) {
      print('Location - Permission Denied');
    }
  } else if (permLocationStatus == PermissionStatus.permanentlyDenied) {
    if (kDebugMode) {
      print('Location - Permission Permanently Denied');
    }
    await openAppSettings();
  }

  if (permNotifyStatus == PermissionStatus.granted) {
    if (kDebugMode) {
      print('Notifications - Permission Granted');
    }
  } else if (permNotifyStatus == PermissionStatus.denied) {
    if (kDebugMode) {
      print('Notifications - Permission Denied');
    }
  } else if (permNotifyStatus == PermissionStatus.permanentlyDenied) {
    if (kDebugMode) {
      print('Notifications - Permission Permanently Denied');
    }
    await openAppSettings();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}
