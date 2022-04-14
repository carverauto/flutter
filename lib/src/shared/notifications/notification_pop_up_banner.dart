import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../const/colors.dart';
import '../../const/images.dart';
import '../../const/other.dart';
import '../../const/sizings.dart';
import '../../models/notification/notification.dart';
import '../enums/interest_enum.dart';
import '../util/extensions/interest_enum.dart';
import '../widgets/builders/image_builder.dart';
import 'notification_handler.dart';
import 'notification_tile.dart';

void showNotificationBanner(
  BuildContext context,
  ChaseAppNotification notification,
) async {
  await showDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.topCenter,
        insetPadding: const EdgeInsets.all(kItemsSpacingMediumConstant),
        child: NotificationPopUpBanner(
          notification: notification,
        ),
      );
    },
  );
}

class NotificationPopUpBanner extends StatefulWidget {
  const NotificationPopUpBanner({Key? key, required this.notification})
      : super(key: key);

  final ChaseAppNotification notification;

  @override
  State<NotificationPopUpBanner> createState() =>
      _NotificationPopUpBannerState();
}

class _NotificationPopUpBannerState extends State<NotificationPopUpBanner> {
  late Timer timer;

  void onTap() {
    timer.cancel();
    Navigator.pop(context);
    notificationHandler(context, widget.notification);
  }

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: Offset(0, -MediaQuery.of(context).size.height * 0.3),
        end: Offset.zero,
      ),
      curve: kPrimaryCurve,
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext context, Offset value, Widget? child) {
        log(value.dy.toString());
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          if (getInterestEnumFromString(widget.notification.interest) ==
              Interests.firehose)
            InkWell(
              onTap: onTap,
              child: IgnorePointer(
                child: NotificationTile(notification: widget.notification),
              ),
            )
          else
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  kBorderRadiusStandard,
                ),
              ),
              tileColor: Theme.of(context).colorScheme.surface,
              leading: AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                    boxShadow: const [
                      BoxShadow(
                        color: primaryShadowColor,
                        blurRadius: blurValue,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                    clipBehavior: Clip.hardEdge,
                    child: AdaptiveImageBuilder(
                      url: widget.notification.data?.image ??
                          defaultAssetChaseImage,
                      //  //     TODO: update later with parser
                      //        parseImageUrl(
                      //         notification.image ?? defaultPhotoURL,
                      //         ImageDimensions.LARGE,
                      //       ),
                      showLoading: false,
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.notification.title,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                widget.notification.body,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: ElevatedButton(
                onPressed: onTap,
                child: const Text('View'),
              ),
            ),
        ],
      ),
    );
  }
}
