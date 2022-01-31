import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isGrantedPermissionsProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final isGrantedPermissions = await checkForPermissionsStatuses();
  return isGrantedPermissions;
});
