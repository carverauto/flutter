import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/notification_permission_bottom_sheet.dart';

Future<void> updateisFirstChaseViewedStatus() async {
  final SharedPreferences sharedPreferances =
      await SharedPreferences.getInstance();
  final bool isFirstChaseViewed =
      sharedPreferances.getBool('isFirstChaseViewed') ?? false;

  if (!isFirstChaseViewed) {
    await sharedPreferances.setBool('isFirstChaseViewed', true);
  }
}

Future<bool?> checkUserNotificationAcceptance() async {
  final SharedPreferences sharedPreferances =
      await SharedPreferences.getInstance();
  final bool? isNotificationsAllowed =
      sharedPreferances.getBool('isNotificationsAllowed');

  return isNotificationsAllowed;
}

Future<bool> updateUserNotificationAcceptance(bool status) async {
  final SharedPreferences sharedPreferances =
      await SharedPreferences.getInstance();
  final bool latestStatus =
      await sharedPreferances.setBool('isNotificationsAllowed', status);

  return latestStatus;
}

Future<void> checkRequestPermissions(BuildContext context) async {
  final SharedPreferences sharedPreferances =
      await SharedPreferences.getInstance();
  final bool isFirstChaseViewed =
      sharedPreferances.getBool('isFirstChaseViewed') ?? false;

  if (isFirstChaseViewed) {
    final bool isGrantedPermissions = await checkForPermissionsStatuses();
    final bool? hasUserSeenThisDialog = await checkUserNotificationAcceptance();

    if (hasUserSeenThisDialog == null) {
      if (!isGrantedPermissions) {
        // show request permission bottomsheet
        showNotificationPermissionRequestBottomsheet(context);
      } else {
        await updateUserNotificationAcceptance(true);
      }
    }
  }
}

// ignore: public_member_api_docs
// ignore: long-method
void showNotificationPermissionRequestBottomsheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    clipBehavior: Clip.none,
    isDismissible: false,
    builder: (BuildContext context) {
      return const NotificationsPermissionsDialogView(
        isShownAsBottomSheet: true,
      );
    },
  );
}

Future<bool> checkForPermissionsStatuses() async {
  final bool notificationStatus = await Permission.notification.isGranted;

  return notificationStatus;
}

Future<PermissionStatus> checkPermissionStatusForNotification() async {
  final PermissionStatus notificationStatus =
      await Permission.notification.status;

  return notificationStatus;
}

Future<UsersPermissionStatuses> requestPermissions() async {
  final Map<Permission, PermissionStatus> statuses = await [
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
