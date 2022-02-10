import 'dart:developer';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permanently_denied_dialog.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
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
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: isLoading
          ? CircularAdaptiveProgressIndicator()
          : ElevatedButton(
              style: callToActionButtonStyle,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final UsersPermissionStatuses usersPermissions =
                    await requestPermissions();

                setState(() {
                  isLoading = false;
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
                "Grant All Permissions",
                style: getButtonStyle(context),
              ),
            ),
    );
  }
}
