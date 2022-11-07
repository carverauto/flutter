import 'dart:io';

class AppUpdateInfo {
  AppUpdateInfo({
    required this.app_store,
    required this.current_app_version,
    required this.force_update,
    required this.latest_app_version,
    required this.play_store,
  });

  bool get shouldUpdate {
    if (Platform.isAndroid) {
      return current_app_version < latest_app_version.android;
    } else {
      return current_app_version < latest_app_version.ios;
    }
  }

  bool get forceUpdate => force_update;
  final int current_app_version;
  final LatestAppVersion latest_app_version;
  final bool force_update;
  final String play_store;
  final String app_store;
}

class LatestAppVersion {
  LatestAppVersion({
    required this.android,
    required this.ios,
  });
  final int ios;
  final int android;
}
