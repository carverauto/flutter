import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaseAppDrawer extends StatelessWidget {
  const ChaseAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(userStreamProvider);

              return state.maybeWhen(
                data: (userData) {
                  final isImagePresent = userData.photoURL != null;
                  return InkWell(
                    onTap: () async {
                      final shouldSignOut = await Navigator.pushNamed<bool>(
                          context, RouteName.PROFILE);

                      if (shouldSignOut != null && shouldSignOut) {
                        ref.read(authRepoProvider).signOut();
                      }
                    },
                    child: DrawerHeader(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor.shade800,
                            backgroundImage: NetworkImage(
                              userData.photoURL ?? defaultPhotoURL,
                            ),
                          ),
                          SizedBox(
                            width: kItemsSpacingSmallConstant,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userData.userName != null)
                                Text(
                                  userData.userName!,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              Text(
                                userData.email,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                orElse: () => SizedBox.shrink(),
              );
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.ABOUT_US);
            },
            leading: Icon(
              Icons.people_outline,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              "About Us",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.CREDITS);
            },
            leading: Icon(
              Icons.stars_outlined,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              "Credits",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.SETTINGS);
            },
            leading: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              "Settings",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          Spacer(),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Privacy policy",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(privacyPolicy);
                      },
                  ),
                  TextSpan(
                    text: " . ",
                    style: TextStyle(
                      color: primaryColor.shade400,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: "Tos",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(tosPolicy);
                      },
                  ),
                ])),
          )
        ],
      ),
    );
  }
}
