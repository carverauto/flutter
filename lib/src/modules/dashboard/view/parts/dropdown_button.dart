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
            Navigator.pushNamed(context, RouteName.ABOUT_US);
            break;
          case 2:
            await launchUrl(privacyPolicy);
            break;
          case 3:
            await launchUrl(tosPolicy);
            break;
          case 4:
            ref.read(authRepoProvider).signOut();

            break;
          default:
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Text("Profile"),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text("About"),
        ),
        PopupMenuDivider(),
        const PopupMenuItem<int>(
          value: 2,
          child: Text("Privacy Policy"),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Text("Terms of Service"),
        ),
        PopupMenuDivider(),
        const PopupMenuItem<int>(
          value: 4,
          child: Text("Log out"),
        ),
      ],
    );
  }
}
