import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../../const/app_bundle_info.dart';
import '../../../../const/colors.dart';
import '../../../../const/images.dart';
import '../../../../const/links.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/notifiers/in_app_purchases_state_notifier.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/user/user_data.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../../shared/shaders/confetti/confetti_shader_view.dart';
import '../../../../shared/util/helpers/launchLink.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../chats/view/providers/providers.dart';
import '../../../firehose/view/providers/providers.dart';

class ChaseAppDrawer extends ConsumerWidget {
  const ChaseAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPremiumMember =
        ref.read(inAppPurchasesStateNotifier).value?.isPremiumMember ?? false;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final AsyncValue<UserData> state = ref.watch(userStreamProvider);

              return state.maybeWhen(
                data: (UserData userData) {
                  Widget header = InkWell(
                    onTap: () async {
                      final bool? shouldSignOut =
                          await Navigator.pushNamed<bool>(
                        context,
                        RouteName.PROFILE,
                      );

                      if (shouldSignOut != null && shouldSignOut) {
                        await preLogoutCleanUp(ref);
                        await ref.read(authRepoProvider).signOut();
                      }
                    },
                    child: DrawerHeader(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isPremiumMember)
                            const GlassBg(
                              child: AnimatingGradientShaderBuilder(
                                child: Text(
                                  '✨Premium Member',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: kPaddingSmallConstant,
                          ),
                          Row(
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
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (userData.userName != null)
                                      Text(
                                        userData.userName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                      ),
                                    Text(
                                      userData.email ?? '',
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: kPaddingXSmallConstant,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                  if (isPremiumMember) {
                    header = Stack(
                      children: [
                        const Positioned.fill(
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: ConfettiShaderView(
                              child: ColoredBox(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        header,
                      ],
                    );
                  }

                  return header;
                },
                orElse: SizedBox.shrink,
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
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
                AnimatingGradientShaderBuilder(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.IN_APP_PURCHASES);
                    },
                    leading: Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    title: Text(
                      'ChaseApp Premium',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.CHANGELOGS);
                  },
                  leading: Icon(
                    Icons.update_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Changelogs',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  title: const Text('Rate Us'),
                  onTap: () async {
                    final InAppReview inAppReview = InAppReview.instance;

                    await inAppReview.openStoreListing(
                      appStoreId: AppBundleInfo.appstoreId,
                    );
                  },
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
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteName.SUPPORT);
                  },
                  leading: Icon(
                    Icons.help_outline,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Support',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

Future<void> preLogoutCleanUp(WidgetRef ref) async {
  ref.refresh(
    firehoseServiceStateNotifierProvider.notifier,
  );
  await ref.read(streamChatClientProvider).disconnectUser();

  ref.refresh(chatsServiceStateNotifierProvider.notifier);
  final bool isChatServicesDisposed =
      !ref.read(chatsServiceStateNotifierProvider.notifier).mounted;
  if (isChatServicesDisposed) {
    ref.read(chatsServiceStateNotifierProvider.notifier).dispose();
  }
}
