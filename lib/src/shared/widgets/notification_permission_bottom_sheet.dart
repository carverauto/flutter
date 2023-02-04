import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../const/images.dart';
import '../../const/sizings.dart';
import '../../core/modules/auth/view/providers/providers.dart';
import '../../modules/notifications/view/parts/notification_settings.dart';
import '../shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../util/helpers/request_permissions.dart';

class NotificationsPermissionsDialogView extends ConsumerStatefulWidget {
  const NotificationsPermissionsDialogView({
    super.key,
    required this.isShownAsBottomSheet,
    this.showActions = true,
  });

  final bool isShownAsBottomSheet;
  final bool showActions;

  @override
  ConsumerState<NotificationsPermissionsDialogView> createState() =>
      _NotificationsPermissionsDialogViewState();
}

class _NotificationsPermissionsDialogViewState
    extends ConsumerState<NotificationsPermissionsDialogView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.amber,
                ),
                const SizedBox(
                  width: kPaddingXSmallConstant,
                ),
                AnimatingGradientShaderBuilder(
                  child: Text(
                    'Chase Alerts',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kPaddingSmallConstant,
            ),
            Text(
              'Recieve notification alerts when a chase happens!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: kPaddingSmallConstant,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  //load chaseapp logo
                  ClipOval(
                    child: Image.asset(
                      chaseAppLogoAssetImage,
                      height: 64,
                      width: 64,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: -pi * 2 * _controller.value,
                        child: child,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          right: -150,
                          child: Image.asset(
                            mapHeliSymbol,
                            height: kIconSizeLargeConstant,
                            width: kIconSizeLargeConstant,
                          ),
                        ),

                        // load plane svg
                        Positioned.fill(
                          left: -150,
                          child: Transform.rotate(
                            angle: pi,
                            child: Image.asset(
                              mapPlaneSymbol,
                              height: kIconSizeLargeConstant,
                              width: kIconSizeLargeConstant,
                            ),
                          ),
                        ),
                        // load boat svg
                        Positioned.fill(
                          top: -150,
                          child: Transform.rotate(
                            angle: -pi / 2,
                            child: Image.asset(
                              mapBoatSymbol,
                              height: kIconSizeLargeConstant,
                              width: kIconSizeLargeConstant,
                            ),
                          ),
                        ),
                        // load donut svg
                        Positioned.fill(
                          bottom: -150,
                          child: Center(
                            child: SvgPicture.asset(
                              donutSVG,
                              height: kIconSizeLargeConstant,
                              width: kIconSizeLargeConstant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showActions)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        await requestPermissions();
                        final PermissionStatus notificationPermissionStatus =
                            await checkPermissionStatusForNotification();
                        if (notificationPermissionStatus ==
                            PermissionStatus.granted) {
                          await updateUserNotificationAcceptance(true);
                          await ref
                              .read(postLoginStateNotifierProvider.notifier)
                              .checkUsersInterests();
                        }

                        if (widget.isShownAsBottomSheet) {
                          Navigator.of(context).pop(
                            notificationPermissionStatus ==
                                PermissionStatus.granted,
                          );
                        } else {
                          ref.refresh(userNotificationAcceptanceFutureProvider);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(kPaddingSmallConstant),
                        child: Text('Enable'),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: kPaddingMediumConstant,
            ),
            if (widget.showActions)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onPressed: () async {
                        await updateUserNotificationAcceptance(false);

                        if (widget.isShownAsBottomSheet) {
                          Navigator.of(context).pop(false);
                        } else {
                          ref.refresh(userNotificationAcceptanceFutureProvider);
                        }
                      },
                      child: const Text(
                        'Remind Later',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
