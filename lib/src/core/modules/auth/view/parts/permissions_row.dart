import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';

class PermissionRow extends StatelessWidget {
  const PermissionRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.info,
  }) : super(key: key);

  //get icon and text
  final IconData icon;

  final String title;

  final String subTitle;

  final String info;

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
        style: Sizescaleconfig.getDeviceType == DeviceType.SMALL_MOBILE
            ? Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )
            : Theme.of(context).textTheme.headline5!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
      ),
      subtitle: Text(
        info,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground.withAlpha(190),
        ),
      ),
    );
  }
}
