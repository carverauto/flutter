import 'package:chaseapp/src/core/modules/auth/view/pages/auth_view_wrapper.dart';
import 'package:chaseapp/src/core/modules/auth/view/pages/check_permissions.dart';
import 'package:chaseapp/src/modules/onboarding/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckPermissionsViewWrapper extends ConsumerWidget {
  const CheckPermissionsViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(isGrantedPermissionsProvider).when(
        data: (isGrantedPermissions) {
          return isGrantedPermissions
              ? AuthViewWrapper()
              : CheckPermissionsView();
        },
        error: (e, stk) {
          return ChaseAppErrorWidget(onRefresh: () {
            ref.refresh(isGrantedPermissionsProvider);
          });
        },
        loading: () => CircularAdaptiveProgressIndicator());
  }
}
