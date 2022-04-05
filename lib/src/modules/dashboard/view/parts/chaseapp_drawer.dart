import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/colors.dart';
import '../../../../const/images.dart';
import '../../../../const/links.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../models/user/user_data.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/util/helpers/launchLink.dart';
import '../../../chats/view/providers/providers.dart';

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
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final AsyncValue<UserData> state = ref.watch(userStreamProvider);

              return state.maybeWhen(
                data: (UserData userData) {
                  return InkWell(
                    onTap: () async {
                      final bool? shouldSignOut =
                          await Navigator.pushNamed<bool>(
                        context,
                        RouteName.PROFILE,
                      );

                      if (shouldSignOut != null && shouldSignOut) {
                        await ref
                            .refresh(chatsServiceStateNotifierProvider.notifier)
                            .dispose();
                        await ref.read(authRepoProvider).signOut();
                      }
                    },
                    child: DrawerHeader(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor.shade800,
                            backgroundImage: NetworkImage(
                              userData.photoURL ?? defaultPhotoURL,
                            ),
                          ),
                          const SizedBox(
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
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                orElse: SizedBox.shrink,
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
              'About Us',
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
              'Credits',
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
              'Settings',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Privacy policy',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(privacyPolicy);
                      },
                  ),
                  TextSpan(
                    text: ' . ',
                    style: TextStyle(
                      color: primaryColor.shade400,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: 'Tos',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(tosPolicy);
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
