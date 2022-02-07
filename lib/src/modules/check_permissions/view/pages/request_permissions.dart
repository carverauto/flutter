import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/info.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/grant_permissions_button.dart';
import 'package:chaseapp/src/core/modules/auth/view/parts/permissions_list.dart';
import 'package:flutter/material.dart';

class RequestPermissionsView extends StatelessWidget {
  const RequestPermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.all(kPaddingMediumConstant).copyWith(bottom: 0),
        child: ListView(
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
              height: kItemsSpacingMediumConstant,
            ),
            Container(
              padding: EdgeInsets.all(
                kListPaddingConstant,
              ),
              decoration: BoxDecoration(
                color: primaryColor.shade500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  Expanded(
                    child: Text(
                      permissionsTitle,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kItemsSpacingLarge,
            ),
            PermissionsList(),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
            GrantAllPermissionsButton(),
            SizedBox(
              height: kItemsSpacingMedium,
            ),
          ],
        ),
      ),
    );
  }
}
