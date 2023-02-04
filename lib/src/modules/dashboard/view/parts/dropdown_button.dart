import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/links.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/util/helpers/launchLink.dart';

class ChaseAppDropDownButton extends ConsumerWidget {
  const ChaseAppDropDownButton({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<int>(
      offset: Offset(0, kImageSizeMedium * 2),
      onSelected: (int actionIndex) async {
        switch (actionIndex) {
          case 0:
            await Navigator.pushNamed(context, RouteName.PROFILE);
            break;
          case 1:
            await Navigator.pushNamed(context, RouteName.CREDITS);
            break;
          case 2:
            await Navigator.pushNamed(context, RouteName.ABOUT_US);
            break;
          case 3:
            await launchUrl(privacyPolicy);
            break;
          case 4:
            await launchUrl(tosPolicy);
            break;
          case 5:
            await ref.read(authRepoProvider).signOut();

            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Text(
            'Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            'Credits',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            'About',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: Text(
            'Terms of Service',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 5,
          child: Text(
            'Log out',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}
