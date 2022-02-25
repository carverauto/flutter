import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: notificationData.id,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryShadowColor,
                        blurRadius: blurValue,
                        offset: Offset(0, 2),
                      )
                    ],
                    color: Theme.of(context).cardColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.hardEdge,
                    child: AdaptiveImageBuilder(
                      url: notificationData.image ?? defaultPhotoURL,
                      showLoading: false,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: kItemsSpacingMediumConstant,
            ),
            Text(
              notificationData.title ?? "NA",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            Text(
              notificationData.body ?? "NA",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: kItemsSpacingLargeConstant,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  side: BorderSide(
                    color: Colors.white,
                  )),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
