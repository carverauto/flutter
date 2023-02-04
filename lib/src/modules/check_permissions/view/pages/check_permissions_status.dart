import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../../core/modules/auth/view/pages/auth_view_wrapper.dart';

class CheckPermissionsViewWrapper extends StatelessWidget {
  CheckPermissionsViewWrapper({super.key});

  final Logger logger = Logger('CheckPermissionsView');

  @override
  Widget build(BuildContext context) {
    return AuthViewWrapper();
    // return ProviderStateBuilder<bool>(
    //   builder: (bool isGrantedPermissions, WidgetRef ref, Widget? child) {
    //     return isGrantedPermissions
    //         ? AuthViewWrapper()
    //         : const RequestPermissionsView();
    //   },
    //   watchThisProvider: isGrantedPermissionsProvider,
    //   logger: logger,
    // );
  }
}
