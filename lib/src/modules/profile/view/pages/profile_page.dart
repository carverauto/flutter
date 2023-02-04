// flutter_ignore: dart_io_import.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/user/user_data.dart';
import '../../../../shared/widgets/brand/chaseapp_brand_widgets.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import '../../../dashboard/view/parts/chaseapp_drawer.dart';
import '../../../firehose/view/providers/providers.dart';
import '../../../onboarding/view/pages/onboarding.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Logger logger = Logger('Profile');

  bool deletingAccount = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !deletingAccount;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: false,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const ChaseappInfoDialog();
                  },
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        body: ProviderStateBuilder<UserData>(
          watchThisProvider: userStreamProvider,
          logger: logger,
          builder: (UserData user, WidgetRef ref, Widget? child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: kPaddingMediumConstant,
                  ),
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: CircleAvatar(
                          radius: kImageSizeLarge,
                          backgroundImage: CachedNetworkImageProvider(
                            user.photoURL ?? defaultPhotoURL,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kItemsSpacingSmallConstant,
                      ),
                      if (user.userName != null)
                        Text(
                          user.userName!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      Text(
                        user.email ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      const Spacer(),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromWidth(double.maxFinite),
                          ),
                          onPressed: () async {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kPaddingLargeConstant,
                      ),
                      Row(
                        children: const [
                          SizedBox(
                            width: kPaddingSmallConstant,
                            child: Divider(
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Danger Zone',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: kPaddingMediumConstant,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size.fromWidth(double.maxFinite),
                          ),
                          onPressed: () async {
                            final bool? shouldDelete = await showDialog<bool?>(
                              context: context,
                              builder: (BuildContext context) {
                                return Platform.isIOS
                                    ? CupertinoAlertDialog(
                                        title: const Text('Delete Account'),
                                        content: const Text(
                                          'Are you sure you want to delete your account?',
                                        ),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                        ],
                                      )
                                    : AlertDialog(
                                        title: const Text('Delete Account'),
                                        content: const Text(
                                          'Are you sure you want to delete your account?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                              },
                            );

                            if (mounted) {
                              if (shouldDelete != null && shouldDelete) {
                                await preLogoutCleanUp(ref);
                                final String userId = ref
                                    .read(firebaseAuthProvider)
                                    .currentUser!
                                    .uid;
                                // clear local keys

                                setState(() {
                                  deletingAccount = true;
                                });
                                await ref
                                    .read(sharedPreferancesProvider)
                                    .clear();
                                try {
                                  await Future<void>.delayed(
                                    const Duration(seconds: 2),
                                  );
                                  // return;
                                  await ref
                                      .read(
                                        firehoseServiceStateNotifierProvider
                                            .notifier,
                                      )
                                      .streamFeedClient
                                      .deleteUser(userId);
                                  final bool isDisposed = ref
                                      .read(
                                        firehoseServiceStateNotifierProvider
                                            .notifier,
                                      )
                                      .mounted;
                                  if (!isDisposed) {
                                    ref
                                        .read(
                                          firehoseServiceStateNotifierProvider
                                              .notifier,
                                        )
                                        .dispose();
                                  }
                                  await ref
                                      .read(authRepoProvider)
                                      .deleteUserAccount(userId);

                                  setState(() {
                                    deletingAccount = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Account deleted successfully.'),
                                    ),
                                  );
                                  await ref.read(authRepoProvider).signOut();
                                  await Navigator.pushAndRemoveUntil<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const OnBoardingView(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } catch (e) {
                                  setState(() {
                                    deletingAccount = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Something went wrong. Try again later.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kPaddingLargeConstant,
                      ),
                    ],
                  ),
                ),
                if (deletingAccount)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const CircularAdaptiveProgressIndicatorWithBg(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ChaseappInfoDialog extends ConsumerWidget {
  const ChaseappInfoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PackageInfo packageInfo = ref.read(appInfoProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey[300],
                  ),
              headlineSmall:
                  Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                      ),
            ),
      ),
      child: AboutDialog(
        applicationName: 'ChaseApp',
        applicationVersion: 'v ${packageInfo.version}',
        applicationIcon: const ChaseAppLogoImage(),
      ),
    );
  }
}
