import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<UsersPermissionStatuses> requestPermissions() async {
  const blutoothScanService = Permission.bluetoothScan;
  const blutoothConnectService = Permission.bluetoothConnect;
  const blutoothService = Permission.bluetooth;
  const locationAlwayOnService = Permission.locationAlways;
  const locationOnService = Permission.location;
  const notificationService = Permission.notification;

  bool isBlutoothPermissionGranted = await blutoothService.isGranted;
  bool isBlutoothScanOnPermissionGranted = await blutoothScanService.isGranted;
  bool isBlutoothConnectOnPermissionGranted =
      await blutoothConnectService.isGranted;
  bool isLocationOnPermissionGranted = await locationOnService.isGranted;
  bool isLocationAlwaysOnPermissionGranted =
      await locationAlwayOnService.isGranted;
  bool isNotificationsPermissionGranted = await notificationService.isGranted;

  Map<Permission, PermissionStatus> statuses = await [
    if (!isBlutoothPermissionGranted) Permission.bluetooth,
    if (Platform.isAndroid) ...[
      if (!isBlutoothScanOnPermissionGranted) Permission.bluetoothScan,
      if (!isBlutoothConnectOnPermissionGranted) Permission.bluetoothConnect,
    ],
    if (!isLocationOnPermissionGranted) Permission.location,
    if (!isLocationAlwaysOnPermissionGranted) Permission.locationAlways,
    if (!isNotificationsPermissionGranted) Permission.notification,
  ].request();

  List<Permission> permanentlyDeniedPermissions = [];

  for (var entry in statuses.entries) {
    final status = entry.value;
    if (status == PermissionStatus.granted) {
      if (kDebugMode) {
        print('BTServiceStatus - Permission Granted');
      }
    } else if (status == PermissionStatus.denied) {
      if (kDebugMode) {
        print('BTServiceStatus - Permission Denied');
      }

      return UsersPermissionStatuses(
        UsersPermissionStatus.DENIED,
        permanentlyDeniedPermissions,
      );
    } else if (status == PermissionStatus.permanentlyDenied) {
      log(entry.key.toString());
      permanentlyDeniedPermissions.add(entry.key);
      if (kDebugMode) {
        print('BTServiceStatus - Permission Permanently Denied');
      }
    }
  }

  return UsersPermissionStatuses(
    permanentlyDeniedPermissions.isNotEmpty
        ? UsersPermissionStatus.PERMANENTLY_DENIED
        : UsersPermissionStatus.ALLOWED,
    permanentlyDeniedPermissions,
  );

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
}

class UsersPermissionStatuses {
  UsersPermissionStatuses(
    this.status,
    this.permanentlyDeniedPermissions,
  );
  final UsersPermissionStatus status;
  final List<Permission> permanentlyDeniedPermissions;
}

enum UsersPermissionStatus {
  ALLOWED,
  DENIED,
  PERMANENTLY_DENIED,
}
