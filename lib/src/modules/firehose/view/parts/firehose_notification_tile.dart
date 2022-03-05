import 'package:cached_network_image/cached_network_image.dart';
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
            return ListTile(
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
                overflow: TextOverflow.ellipsis,
              ),
              trailing: ImageIcon(
                CachedNetworkImageProvider(notification.data!.image!),
                color: Colors.blue,
              ),
            );
          },
          watchThisProvider:
              fetchTweetAlongUserData(notification.data!.tweetId!),
          logger: logger);
    } else if (notification.title == "streams") {
      return ListTile(
        onTap: () {
          showFirehosePreview(notification, context);
        },
        leading: CircleAvatar(
          backgroundImage:
              CachedNetworkImageProvider(notification.data!.image!),
        ),
        title: Text("Youtube"),
        subtitle: Text(notification.body!),
        trailing: ImageIcon(
          CachedNetworkImageProvider(notification.data!.image!),
          color: Colors.blue,
        ),
      );
    } else {
      return Container(
        color: Colors.green,
      );
    }
  }
}
