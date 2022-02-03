import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
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
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: Sizescaleconfig.getDeviceType == DeviceType.MOBILE
            ? Theme.of(context).textTheme.subtitle1!
            : Theme.of(context).textTheme.headline5!,
      ),
      subtitle: Text(
        subTitle,
      ),
      onTap: () {},
    );
  }
}
