class AppUpdateInfo {
  AppUpdateInfo({
    required this.app_store,
    required this.current_app_version,
    required this.force_update,
    required this.latest_app_version,
    required this.play_store,
  });

  bool get shouldUpdate => current_app_version != latest_app_version;
  bool get forceUpdate => force_update;
  final String current_app_version;
  final String latest_app_version;
  final bool force_update;
  final String play_store;
  final String app_store;
}
