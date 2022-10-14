import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateisFirstChaseViewedStatus() async {
  final SharedPreferences sharedPreferances =
      await SharedPreferences.getInstance();
  final bool isFirstChaseViewed =
      sharedPreferances.getBool('isFirstChaseViewed') ?? false;

  if (!isFirstChaseViewed) {
    await sharedPreferances.setBool('isFirstChaseViewed', true);
  }
}

Future<void> checkRequestPermissions() async {
  final SharedPreferences sharedPreferances =
      await SharedPreferences.getInstance();
  final bool isFirstChaseViewed =
      sharedPreferances.getBool('isFirstChaseViewed') ?? false;

  if (isFirstChaseViewed) {
    final bool isGrantedPermissions = await _checkForPermissionsStatuses();

    if (!isGrantedPermissions) {
      await _requestPermissions();
    }
  }
}

Future<bool> _checkForPermissionsStatuses() async {
  // final bool bluetoothStatus = await Permission.bluetooth.isGranted;
  // final bool bluetoothScanStatus =
  //     Platform.isAndroid ? await Permission.bluetoothScan.isGranted : true;
  // final bool bluetoothConnectStatus =
  //     Platform.isAndroid ? await Permission.bluetoothConnect.isGranted : true;
  // final bool locationStatus = await Permission.locationWhenInUse.isGranted;
  final bool notificationStatus = await Permission.notification.isGranted;

  return notificationStatus;

  // return bluetoothStatus &&
  //     bluetoothScanStatus &&
  //     bluetoothConnectStatus &&
  //     locationStatus &&
  //     notificationStatus;
}

Future<UsersPermissionStatuses> _requestPermissions() async {
  final Map<Permission, PermissionStatus> statuses = await [
    // Permission.bluetooth,
    // if (Platform.isAndroid) ...[
    //   Permission.bluetoothScan,
    //   Permission.bluetoothConnect,
    // ],
    // Permission.locationWhenInUse,
    Permission.notification,
  ].request();

  final List<Permission> permanentlyDeniedPermissions = [];

  for (final MapEntry<Permission, PermissionStatus> entry in statuses.entries) {
    final PermissionStatus status = entry.value;
    if (status == PermissionStatus.granted) {
      if (kDebugMode) {
        log('BTServiceStatus - Permission Granted');
      }
    } else if (status == PermissionStatus.denied) {
      if (kDebugMode) {
        log('BTServiceStatus - Permission Denied');
      }

      return UsersPermissionStatuses(
        UsersPermissionStatus.DENIED,
        permanentlyDeniedPermissions,
      );
    } else if (status == PermissionStatus.permanentlyDenied) {
      permanentlyDeniedPermissions.add(entry.key);
      if (kDebugMode) {
        log('BTServiceStatus - Permission Permanently Denied');
      }
    }
  }

  return UsersPermissionStatuses(
    permanentlyDeniedPermissions.isNotEmpty
        ? UsersPermissionStatus.PERMANENTLY_DENIED
        : UsersPermissionStatus.ALLOWED,
    permanentlyDeniedPermissions,
  );
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
