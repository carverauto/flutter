import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/show_preview_dialog.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FirehoseNotificationTile extends StatelessWidget {
  FirehoseNotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  final Logger logger = Logger('FirehoseNotificationTile');

  @override
  Widget build(BuildContext context) {
    if (notification.title == "twitter") {
      return ProviderStateBuilder<TweetData>(
          builder: (tweetData, ref) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: kItemsSpacingSmallConstant,
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                ),
                tileColor: Colors.white,
                onTap: () {
                  showFirehosePreview(notification, context);
                },
                leading: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(tweetData.profileImageUrl),
                ),
                title: Text(
                  tweetData.text,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: ImageIcon(
                  CachedNetworkImageProvider(notification.data!.image!),
                  color: Colors.blue,
                ),
              ),
            );
          },
          watchThisProvider:
              fetchTweetAlongUserData(notification.data!.tweetId!),
          logger: logger);
    } else if (notification.title == "streams") {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: kItemsSpacingSmallConstant,
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusStandard),
          ),
          onTap: () {
            showFirehosePreview(notification, context);
          },
          tileColor: Colors.white,
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(notification.data!.image!),
          ),
          title: Text(
            "Youtube",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          subtitle: Text(
            notification.body!,
            style: TextStyle(
              color: primaryColor.shade300,
            ),
          ),
          trailing: Icon(
            Icons.play_arrow_rounded,
            color: Colors.red,
            size: kIconSizeMediumConstant,
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.green,
      );
    }
  }
}
