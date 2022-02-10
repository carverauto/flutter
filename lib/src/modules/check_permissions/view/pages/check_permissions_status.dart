import 'package:chaseapp/src/core/modules/auth/view/pages/auth_view_wrapper.dart';
import 'package:chaseapp/src/modules/check_permissions/view/pages/request_permissions.dart';
import 'package:chaseapp/src/modules/onboarding/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class CheckPermissionsViewWrapper extends ConsumerWidget {
  CheckPermissionsViewWrapper({Key? key}) : super(key: key);

  final Logger logger = Logger("CheckPermissionsView");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderStateBuilder<bool>(
      builder: (isGrantedPermissions) {
        return isGrantedPermissions
            ? AuthViewWrapper()
            : RequestPermissionsView();
      },
      watchThisProvider: isGrantedPermissionsProvider,
      logger: logger,
    );
  }
}
