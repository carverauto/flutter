import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/show_preview_dialog.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/firehose_notification_type.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FirehoseNotificationTile extends ConsumerWidget {
  FirehoseNotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  final Logger logger = Logger('FirehoseNotificationTile');

  final titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationType =
        getFirehoseNotificationTypeFromString(notification.title);
    switch (notificationType) {
      case FirehoseNotificationType.twitter:
        return ProviderStateBuilder<TweetData>(
            loadingBuilder: () => LoadingListTile(),
            errorBuilder: (e, stk) {
              return FirehoseErrorTile(
                  notification: notification,
                  onRefesh: () {
                    ref.refresh(
                        fetchTweetAlongUserData(notification.data!.tweetId!));
                  });
            },
            builder: (tweetData, ref, child) {
              return _FirehoseNotificationListTile(
                notification: notification,
                body: tweetData.text,
                imageUrl: tweetData.profileImageUrl,
                title: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: tweetData.name,
                        style: titleStyle,
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: "@" + tweetData.userName,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
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

      case FirehoseNotificationType.streams:
        return _FirehoseNotificationListTile(
          notification: notification,
          title: Text(
            "Youtube",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          body: notification.body,
          imageUrl: notification.data!.image!,
          trailing: Icon(
            Icons.play_arrow_rounded,
            color: Colors.red,
            size: kIconSizeMediumConstant,
          ),
        );
      case FirehoseNotificationType.live_on_patrol:
        return _FirehoseNotificationListTile(
          notification: notification,
          title: Text(
            notification.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          body: notification.body,
          trailing: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.red,
                ],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.local_police_rounded,
              color: Colors.white,
            ),
          ),
          //  ImageIcon(
          //   AssetImage(defaultAssetChaseImage,),
          //   size: 24,
          // ),
          imageUrl: notification.data!.image!,
        );
      default:
        return SizedBox.shrink();
    }
  }
}

class FirehoseErrorTile extends StatelessWidget {
  const FirehoseErrorTile({
    Key? key,
    required this.notification,
    required this.onRefesh,
  }) : super(key: key);

  final ChaseAppNotification notification;
  final VoidCallback onRefesh;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white70,
      title: TextButton.icon(
        onPressed: onRefesh,
        icon: IconButton(
          onPressed: onRefesh,
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
        label: Text(
          "Failed to load tweet!",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      trailing: ImageIcon(
        CachedNetworkImageProvider(notification.data!.image!),
        color: Colors.blue,
      ),
    );
  }
}

class _FirehoseNotificationListTile extends StatelessWidget {
  const _FirehoseNotificationListTile({
    Key? key,
    required this.notification,
    required this.title,
    required this.body,
    required this.trailing,
    required this.imageUrl,
    this.leading,
  }) : super(key: key);

  final ChaseAppNotification notification;
  final Widget title;

  final String body;
  final Widget trailing;
  final String imageUrl;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusStandard),
      ),
      onTap: () {
        showFirehosePreview(notification, context);
      },
      isThreeLine: true,
      tileColor: Color.fromARGB(255, 94, 94, 94),
      leading: leading ??
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(imageUrl),
            backgroundColor: Colors.white,
          ),
      title: title,
      //  Text(
      //   title,
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      //   style: TextStyle(
      //     color: Theme.of(context).colorScheme.onBackground,
      //   ),
      // ),
      subtitle: Text(
        body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      trailing: trailing,
    );
  }
}

class LoadingListTile extends StatefulWidget {
  const LoadingListTile({Key? key}) : super(key: key);

  @override
  State<LoadingListTile> createState() => _LoadingListTileState();
}

class _LoadingListTileState extends State<LoadingListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusStandard),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                transform: GradientRotation(pi / 4),
                colors: [
                  Colors.transparent,
                  Colors.white70,
                  Colors.transparent,
                ],
                stops: [
                  0.0,
                  animationController.value,
                  1.0,
                ],
              ),
            ),
            height: 50,
          );
        });
  }
}
