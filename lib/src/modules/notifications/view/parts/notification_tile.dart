import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_handler.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:flutter/material.dart';

class NotificationTIle extends StatelessWidget {
  const NotificationTIle({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final NotificationData notificationData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        notificationHandler(context, notificationData);
      },
      leading: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Hero(
            tag: notificationData.id!,
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
                  url: notificationData.image ?? defaultAssetChaseImage,
                  //TODO: update later with parser
                  //  parseImageUrl(
                  //   notificationData.image ?? defaultPhotoURL,
                  //   ImageDimensions.SMALL,
                  // ),
                  showLoading: false,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(notificationData.title ?? "NA",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          )),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              notificationData.body ?? "NA",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryColor.shade300,
              ),
            ),
          ),
          SizedBox(
            width: kItemsSpacingExtraSmallConstant,
          ),
          Text(
            notificationData.createdAt != null
                ? elapsedTimeForDate(notificationData.createdAt!)
                : "NA",
            style: TextStyle(
              color: primaryColor.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
