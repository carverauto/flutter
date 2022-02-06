import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaseAppDropDownButton extends ConsumerWidget {
  const ChaseAppDropDownButton({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<int>(
      child: child,
      offset: Offset(0, kImageSizeMedium * 2),
      onSelected: (int actionIndex) async {
        switch (actionIndex) {
          case 0:
            Navigator.pushNamed(context, RouteName.PROFILE);
            break;
          case 1:
            Navigator.pushNamed(context, RouteName.CREDITS);
            break;
          case 2:
            Navigator.pushNamed(context, RouteName.ABOUT_US);
            break;
          case 3:
            await launchUrl(privacyPolicy);
            break;
          case 4:
            await launchUrl(tosPolicy);
            break;
          case 5:
            ref.read(authRepoProvider).signOut();

            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Text(
            "Profile",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            "Credits",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            "About",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            "Privacy Policy",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: Text(
            "Terms of Service",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 5,
          child: Text(
            "Log out",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
