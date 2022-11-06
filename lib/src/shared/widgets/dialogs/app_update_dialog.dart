// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../const/colors.dart';
import '../../../const/sizings.dart';
import '../../../models/app_update_info/app_update_info.dart';
import '../../util/helpers/launchLink.dart';

// ignore: long-method
Future<void> showUpdateDialog(
  BuildContext context,
  AppUpdateInfo appUpdateInfo,
) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    await showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: Icon(
                Icons.update,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              width: kItemsSpacingSmallConstant,
            ),
            const Flexible(
              child: Text(
                'Update Required!',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'A new version of the ChaseApp is available. Please update the app to continue.',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(kButtonPaddingMedium),
            ),
            onPressed: () async {
              final String storeUrl = Platform.isAndroid
                  ? appUpdateInfo.play_store
                  : appUpdateInfo.app_store;
              await launchUrl(storeUrl);
            },
            child: const Text(
              'Update',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(
            width: kPaddingSmallConstant,
          ),
          if (!appUpdateInfo.forceUpdate)
            TextButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(kButtonPaddingMedium),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(
                'Remind Later',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
        ],
      ),
    );
  } else {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: Icon(
                Icons.update,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
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
            style: OutlinedButton.styleFrom(
              backgroundColor: primaryButtonsColor,
              padding: const EdgeInsets.all(kButtonPaddingMedium),
            ),
            onPressed: () async {
              final String storeUrl = Platform.isAndroid
                  ? appUpdateInfo.play_store
                  : appUpdateInfo.app_store;
              await launchUrl(storeUrl);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          if (!appUpdateInfo.forceUpdate)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(kButtonPaddingMedium),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(
                'Remind Later',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
