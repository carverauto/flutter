import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/notifiers/in_app_purchases_state_notifier.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/interest/interest.dart';
import '../../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../../shared/util/helpers/request_permissions.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../../shared/widgets/notification_permission_bottom_sheet.dart';
import '../providers/providers.dart';
import 'notification_setting_tile.dart';

final AutoDisposeFutureProvider<NotificationPermissionStatuses>
    userNotificationAcceptanceFutureProvider =
    FutureProvider.autoDispose<NotificationPermissionStatuses>((
  AutoDisposeFutureProviderRef<NotificationPermissionStatuses> ref,
) async {
  final bool? userPermissionDialogAcceptance =
      await checkUserNotificationAcceptance();
  final bool permissionFromDevice = await checkForPermissionsStatuses();

  return NotificationPermissionStatuses(
    permissionFromDevice: permissionFromDevice,
    userPermissionDialogAcceptance: userPermissionDialogAcceptance,
  );
});

class NotificationPermissionStatuses {
  NotificationPermissionStatuses({
    required this.permissionFromDevice,
    required this.userPermissionDialogAcceptance,
  });

  final bool permissionFromDevice;
  final bool? userPermissionDialogAcceptance;
}

class NotificationsSettings extends ConsumerStatefulWidget {
  const NotificationsSettings({super.key});

  @override
  ConsumerState<NotificationsSettings> createState() =>
      _NotificationsSettingsState();
}

class _NotificationsSettingsState extends ConsumerState<NotificationsSettings>
    with WidgetsBindingObserver {
  final Logger logger = Logger('NotificationsSettings');

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      ref.refresh(userNotificationAcceptanceFutureProvider);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<NotificationPermissionStatuses>
        userNotificationAcceptanceState =
        ref.watch(userNotificationAcceptanceFutureProvider);
    final bool isPremiumMember =
        ref.watch(inAppPurchasesStateNotifier).value?.isPremiumMember ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Interests'),
        elevation: 0,
      ),
      body: userNotificationAcceptanceState.when(
        data: (NotificationPermissionStatuses notificationStatus) {
          if (notificationStatus.permissionFromDevice) {
            return ProviderStateBuilder<List<Interest>>(
              builder:
                  (List<Interest> interests, WidgetRef ref, Widget? child) {
                return ProviderStateBuilder<List<String?>>(
                  builder: (
                    List<String?> usersInterests,
                    WidgetRef ref,
                    Widget? child,
                  ) {
                    final List<Interest> defaultInterests = interests
                        .where((Interest interest) => !interest.isPremium)
                        .toList();
                    final List<Interest> premiumInterests = interests
                        .where((Interest interest) => interest.isPremium)
                        .toList();

                    return Padding(
                      padding:
                          const EdgeInsets.all(kPaddingMediumConstant).copyWith(
                        bottom: 0,
                      ),
                      child: CustomScrollView(
                        slivers: [
                          InterestsHeader(
                            name: 'Default',
                            isPremiumMember: isPremiumMember,
                          ),
                          InterestsList(
                            interests: defaultInterests,
                            usersInterests: usersInterests,
                          ),
                          InterestsHeader(
                            name: 'Premium',
                            isPremium: true,
                            isPremiumMember: isPremiumMember,
                          ),
                          InterestsList(
                            interests: premiumInterests,
                            usersInterests: usersInterests,
                          ),
                        ],
                      ),
                    );
                  },
                  watchThisProvider: usersInterestsStreamProvider,
                  logger: logger,
                );
              },
              watchThisProvider: interestsProvider,
              logger: logger,
            );
          }
          if (notificationStatus.userPermissionDialogAcceptance == null) {
            return const NotificationsPermissionsDialogView(
              isShownAsBottomSheet: false,
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMediumConstant),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    child: NotificationsPermissionsDialogView(
                      isShownAsBottomSheet: false,
                      showActions: false,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      children: [
                        Text(
                          'You have Notifications disabled for ChaseApp.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        Text(
                          'If you wish to recieve them, then please enable them and restart the app.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        // add button to enable notification permissions from settings
                        ElevatedButton(
                          onPressed: () async {
                            PermissionStatus permissionStatus =
                                await checkPermissionStatusForNotification();

                            log(permissionStatus.name);

                            if (permissionStatus == PermissionStatus.denied) {
                              await requestPermissions();
                            }
                            if (permissionStatus ==
                                PermissionStatus.permanentlyDenied) {
                              await openAppSettings();
                            }

                            permissionStatus =
                                await checkPermissionStatusForNotification();

                            if (permissionStatus == PermissionStatus.granted) {
                              await ref
                                  .read(postLoginStateNotifierProvider.notifier)
                                  .checkUsersInterests();
                            }

                            ref.refresh(
                              userNotificationAcceptanceFutureProvider,
                            );
                          },
                          child: const Text('Enable'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (Object error, StackTrace? stackTrace) {
          logger.warning(error, error, stackTrace);
          return const Center(
            child: Text(
              'Something went wrong',
            ),
          );
        },
      ),
    );
  }
}

class InterestsHeader extends StatelessWidget {
  const InterestsHeader({
    super.key,
    required this.name,
    this.isPremium = false,
    required this.isPremiumMember,
  });

  final String name;
  final bool isPremium;
  final bool isPremiumMember;

  @override
  Widget build(BuildContext context) {
    Widget row = Row(
      children: [
        if (isPremium)
          const SizedBox(
            width: kItemsSpacingSmallConstant,
          ),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
        const SizedBox(
          width: kItemsSpacingSmallConstant,
        ),
        Expanded(
          child: Divider(
            height: isPremium ? 10 : 1,
            color: isPremium ? Colors.white : null,
          ),
        ),
      ],
    );
    if (isPremium) {
      row = Row(
        children: [
          if (isPremium)
            Icon(
              isPremiumMember ? Icons.lock_open_rounded : Icons.lock,
              color: isPremiumMember ? Colors.green : Colors.red,
            ),
          Expanded(
            child: AnimatingGradientShaderBuilder(
              child: row,
            ),
          ),
        ],
      );
    }

    return SliverToBoxAdapter(
      child: row,
    );
  }
}

class InterestsList extends StatelessWidget {
  const InterestsList({
    super.key,
    required this.interests,
    required this.usersInterests,
  });

  final List<Interest> interests;
  final List<String?> usersInterests;

  @override
  Widget build(BuildContext context) {
    interests.sort((Interest a, Interest b) => a.name.compareTo(b.name));

    return interests.isEmpty
        ? SliverToBoxAdapter(
            child: Column(
              children: [
                // Icon(
                //   Icons.notifications_off_outlined,
                // ),
                Chip(
                  label: Text(
                    'None Found',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ],
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final Interest interest = interests[index];
                final bool isUsersInterest =
                    usersInterests.contains(interest.name);

                return NotificationSettingTile(
                  interest: interest,
                  isUsersInterest: isUsersInterest,
                );
              },
              childCount: interests.length,
            ),
          );
  }
}
