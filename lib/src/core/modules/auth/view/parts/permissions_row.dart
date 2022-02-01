import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class PermissionRow extends StatelessWidget {
  const PermissionRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  //get icon and text
  final IconData icon;

  final String title;

  final String subTitle;

  @override
  Widget build(BuildContext context) {
    //TODO: Need to check on how I can set only some borders with new updates in stlying for buttons
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      style: ListTileStyle.drawer,
      title: Text(title),
      subtitle: Text(subTitle),
      onTap: () {},
    );
  }
}
