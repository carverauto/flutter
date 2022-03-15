import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/images.dart';
import 'package:chaseapp/src/const/other.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/shared/enums/interest_enum.dart';
import 'package:chaseapp/src/shared/notifications/notification_handler.dart';
import 'package:chaseapp/src/shared/notifications/notification_tile.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:flutter/material.dart';

void showNotificationBanner(
  BuildContext context,
  ChaseAppNotification notificationData,
) async {
  showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          insetPadding: EdgeInsets.all(kItemsSpacingMediumConstant),
          child: NotificationPopUpBanner(
            notificationData: notificationData,
          ),
        );
      });
}

class NotificationPopUpBanner extends StatefulWidget {
  const NotificationPopUpBanner({Key? key, required this.notificationData})
      : super(key: key);

  final ChaseAppNotification notificationData;

  @override
  State<NotificationPopUpBanner> createState() =>
      _NotificationPopUpBannerState();
}

class _NotificationPopUpBannerState extends State<NotificationPopUpBanner> {
  late Timer timer;

  void onTap() {
    timer.cancel();
    Navigator.pop(context);
    notificationHandler(context, widget.notificationData);
  }

  @override
  void initState() {
    super.initState();

    timer = Timer(Duration(seconds: 5), () {
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
      duration: Duration(milliseconds: 300),
      builder: (context, value, child) {
        log(value.dy.toString());
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kToolbarHeight,
          ),
          getInterestEnumFromString(widget.notificationData.interest) ==
                  Interests.firehose
              ? InkWell(
                  onTap: onTap,
                  child: IgnorePointer(
                    ignoring: true,
                    child:
                        NotificationTile(notification: widget.notificationData),
                  ),
                )
              : ListTile(
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
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusStandard),
                        boxShadow: [
                          BoxShadow(
                            color: primaryShadowColor,
                            blurRadius: blurValue,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusStandard),
                        clipBehavior: Clip.hardEdge,
                        child: AdaptiveImageBuilder(
                          url: widget.notificationData.image ??
                              defaultAssetChaseImage,
                          //  //     TODO: update later with parser
                          //        parseImageUrl(
                          //         notificationData.image ?? defaultPhotoURL,
                          //         ImageDimensions.LARGE,
                          //       ),
                          showLoading: false,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.notificationData.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    widget.notificationData.body,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: ElevatedButton(
                    onPressed: onTap,
                    child: Text("View"),
                  ),
                ),
        ],
      ),
    );
  }
}
