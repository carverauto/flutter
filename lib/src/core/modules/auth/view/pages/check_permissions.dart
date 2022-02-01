import 'dart:developer';

import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permanently_denied_dialog.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permissions_row.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';

class CheckPermissionsView extends StatelessWidget {
  const CheckPermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: ListView(
          //  crossAxisAlignment: CrossAxisAlignment.center,
          padding: EdgeInsets.all(0),

          children: [
            SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            Image.asset(
              chaseAppNameImage,
              height: kImageSizeLarge,
            ),
            SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(
                  width: kItemsSpacingSmallConstant,
                ),
                Expanded(
                  child: Text(
                    '''Free version of ChaseApp requires following permissions to work properly.\nPlease grant this permissions to procceed.''',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kItemsSpacingLarge,
            ),
            PermissionRow(
              icon: Icons.location_pin,
              title: "Location",
              subTitle: "Location permission for location tracking.",
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            PermissionRow(
              icon: Icons.bluetooth_connected,
              title: "Bluetooth",
              subTitle: "Location permission for location tracking.",
            ),
            Divider(),
            PermissionRow(
              icon: Icons.notifications_active,
              title: "Notifications",
              subTitle: "Location permission for location tracking.",
            ),
            Divider(),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
            GrantAllPermissionsButton(),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
            Row(
              children: [
                Flexible(
                  child: Divider(
                    height: 2,
                    indent: kPaddingLargeConstant,
                    endIndent: kPaddingLargeConstant,
                  ),
                ),
                Text(
                  "Or",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Flexible(
                  child: Divider(
                    height: 2,
                    indent: kPaddingLargeConstant,
                    endIndent: kPaddingLargeConstant,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
            Center(
              child: ElevatedButton(
                style: callToActionButtonStyle,
                onPressed: () {},
                child: Text(
                  "Go Premium!",
                  style: getButtonStyle(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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


//flutter: BTServiceStatus - Permission Permanently Denied
// * thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGKILL
//     frame #0: 0x00000001bd4c4b10 libsystem_kernel.dylib`mach_msg_trap + 8
// libsystem_kernel.dylib`mach_msg_trap:
// ->  0x1bd4c4b10 <+8>: ret
// libsystem_kernel.dylib`mach_msg_overwrite_trap:
//     0x1bd4c4b14 <+0>: mov    x16, #-0x20
//     0x1bd4c4b18 <+4>: svc    #0x80
//     0x1bd4c4b1c <+8>: ret
// Target 0: (Runner) stopped.
// Lost connection to device.
