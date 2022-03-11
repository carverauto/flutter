import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/images.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: notification.id ?? "NA",
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusStandard),
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
                    borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                    clipBehavior: Clip.hardEdge,
                    child: AdaptiveImageBuilder(
                      url: notification.image ?? defaultAssetChaseImage,
                      //TODO: update later with parser
                      //  parseImageUrl(
                      //   notification.image ?? defaultPhotoURL,
                      //   ImageDimensions.LARGE,
                      // ),
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
              notification.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            Text(
              notification.body,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: kItemsSpacingLargeConstant,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
              ),
            )
          ],
        ),
      ),
    );
  }
}
