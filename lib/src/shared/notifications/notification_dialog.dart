import 'package:flutter/material.dart';

import '../../const/colors.dart';
import '../../const/images.dart';
import '../../const/sizings.dart';
import '../../models/notification/notification.dart';
import '../widgets/builders/image_builder.dart';

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
                tag: notification.id ?? 'NA',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: primaryShadowColor,
                        blurRadius: blurValue,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Theme.of(context).cardColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                    clipBehavior: Clip.hardEdge,
                    child: AdaptiveImageBuilder(
                      url: notification.data?.image ?? defaultAssetChaseImage,
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
            const SizedBox(
              height: kItemsSpacingMediumConstant,
            ),
            Text(
              notification.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: kItemsSpacingSmallConstant,
            ),
            Text(
              notification.body,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: kItemsSpacingLargeConstant,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
              ),
            )
          ],
        ),
      ),
    );
  }
}
