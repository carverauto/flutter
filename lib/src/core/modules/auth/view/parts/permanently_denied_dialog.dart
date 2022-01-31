import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> showPermanentlyDeniedDialog(
    BuildContext context, List<Permission> permissions) async {
  if (Platform.isAndroid)
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: DialogTitle(),
            content: DialogContent(
              permissions: permissions,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  side: BorderSide(),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                },
                child: Text("Open App Settings"),
              ),
            ],
          );
        });
  else
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: DialogTitle(),
            content: DialogContent(
              permissions: permissions,
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  await openAppSettings();
                },
                child: Text("Open Settings"),
              ),
            ],
          );
        });
}

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("User Denied Permissions");
  }
}

class DialogContent extends StatelessWidget {
  const DialogContent({
    Key? key,
    required this.permissions,
  }) : super(key: key);

  final List<Permission> permissions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Following permissions are denied for the app. Please grant this permissions by allowing them in the app settings.",
        ),
        ...permissions.asMap().entries.map<Widget>((e) {
          final Permission value = e.value;
          return TextButton.icon(
            onPressed: null,
            icon: Icon(
              Icons.circle,
              size: 10,
            ),
            label: Text(
              value.toString().replaceFirst("Permission.", '').toUpperCase(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        }).toList()
      ],
    );
  }
}
