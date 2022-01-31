import 'dart:developer';

import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permanently_denied_dialog.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permissions_row.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:flutter/material.dart';

class CheckPermissionsView extends StatelessWidget {
  const CheckPermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(chaseAppNameImage),
            Text(
              "Free version of ChaseApp requires following permissions to work properly. ",
              textAlign: TextAlign.center,
            ),
            PermissionRow(
              icon: Icons.info,
              title: "Location permission for location tracking.",
            ),
            PermissionRow(
              icon: Icons.info,
              title: "Location permission for location tracking.",
            ),
            PermissionRow(
              icon: Icons.info,
              title: "Location permission for location tracking.",
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                double.maxFinite,
                50,
              )),
              onPressed: () async {
                final UsersPermissionStatuses usersPermissions =
                    await requestPermissions();

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
                }
              },
              child: Text("Grant Permissions"),
            ),
            Row(
              children: [
                Flexible(
                  child: Divider(
                    height: 2,
                  ),
                ),
                Text("Or"),
                Flexible(
                  child: Divider(
                    height: 2,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                double.maxFinite,
                50,
              )),
              onPressed: () {},
              child: Text("Go Premium!"),
            ),
          ],
        ),
      ),
    );
  }
}
