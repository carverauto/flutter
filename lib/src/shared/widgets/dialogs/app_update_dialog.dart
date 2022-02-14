import 'dart:io';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/app_update_info/app_update_info.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/material.dart';

Future<void> showUpdateDialog(
    BuildContext context, AppUpdateInfo appUpdateInfo) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            child: Icon(
              Icons.update,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(
            width: kItemsSpacingSmallConstant,
          ),
          Flexible(
            child: Text(
              'Update Required!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'A new version of the ChaseApp is available. Please update the app to continue.',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text(
            'Update',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryButtonsColor,
            padding: EdgeInsets.all(kButtonPaddingMedium),
          ),
          onPressed: () async {
            final String storeUrl = Platform.isAndroid
                ? appUpdateInfo.play_store
                : appUpdateInfo.app_store;
            await launchUrl(storeUrl);
          },
        ),
      ],
    ),
  );
}
