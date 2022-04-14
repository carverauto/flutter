import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:logging/logging.dart';

import '../../../../core/modules/auth/view/pages/auth_view_wrapper.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../onboarding/view/providers/providers.dart';
import 'request_permissions.dart';

class CheckPermissionsViewWrapper extends StatelessWidget {
  CheckPermissionsViewWrapper({Key? key}) : super(key: key);

  final Logger logger = Logger('CheckPermissionsView');

  @override
  Widget build(BuildContext context) {
    return ProviderStateBuilder<bool>(
      builder: (bool isGrantedPermissions, WidgetRef ref, Widget? child) {
        return isGrantedPermissions
            ? AuthViewWrapper()
            : const RequestPermissionsView();
      },
      watchThisProvider: isGrantedPermissionsProvider,
      logger: logger,
    );
  }
}
