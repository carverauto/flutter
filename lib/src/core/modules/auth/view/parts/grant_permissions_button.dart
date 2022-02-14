import 'dart:developer';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permanently_denied_dialog.dart';
import 'package:chaseapp/src/modules/signin/view/parts/gradient_animation_container.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:flutter/material.dart';

class GrantAllPermissionsButton extends StatefulWidget {
  const GrantAllPermissionsButton({
    Key? key,
  }) : super(key: key);

  @override
  State<GrantAllPermissionsButton> createState() =>
      _GrantAllPermissionsButtonState();
}

class _GrantAllPermissionsButtonState extends State<GrantAllPermissionsButton> {
  late bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return GradientAnimationChildBuilder(
      shouldAnimate: isLoading,
      child: ElevatedButton(
        style: callToActionButtonStyle,
        onPressed: () async {
          setState(() {
            isLoading = !isLoading;
          });
          await Future<void>.delayed(Duration(seconds: 1));
          final UsersPermissionStatuses usersPermissions =
              await requestPermissions();

          setState(() {
            isLoading = !isLoading;
          });

          if (usersPermissions.status == UsersPermissionStatus.DENIED) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please Grant All Permissions To Proceed."),
            ));
          } else if (usersPermissions.status ==
              UsersPermissionStatus.PERMANENTLY_DENIED) {
            await showPermanentlyDeniedDialog(
              context,
              usersPermissions.permanentlyDeniedPermissions,
            );
          } else {
            //All permissions granted
            log("All Permissions Granted");

            Navigator.pushReplacementNamed(
              context,
              RouteName.AUTH_VIEW_WRAPPER,
            );
          }
        },
        child: Text(
          isLoading ? "Requesting..." : "Grant All Permissions",
          style: getButtonStyle(context),
        ),
      ),
    );
  }
}
