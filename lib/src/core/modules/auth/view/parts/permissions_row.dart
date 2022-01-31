import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class PermissionRow extends StatelessWidget {
  const PermissionRow({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  //get icon and text
  final IconData icon;

  final String title;

  @override
  Widget build(BuildContext context) {
    //TODO: Need to check on how I can set only some borders with new updates in stlying for buttons
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(
        side: BorderSide(),
        shape: RoundedRectangleBorder(),
        padding: EdgeInsets.all(
          kButtonPaddingSmall,
        ),
      ),
      label: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      icon: Icon(
        icon,
      ),
    );
  }
}
