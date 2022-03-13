import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/images.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/models/tweet_data/tweet_data.dart';
import 'package:chaseapp/src/models/youtube_data/youtube_data.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/firehose_notification_type.dart';
import 'package:chaseapp/src/shared/notifications/notification_handler.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationTile extends ConsumerWidget {
  NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  final Logger logger = Logger('NotificationTile');

  final titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationType =
        getFirehoseNotificationTypeFromString(notification.type);
    switch (notificationType) {
      case FirehoseNotificationType.twitter:
        return ProviderStateBuilder<TweetData>(
            loadingBuilder: () => LoadingListTile(
                  height: 50,
                ),
            errorBuilder: (e, stk) {
              return FirehoseErrorTile(
                  notification: notification,
                  onRefesh: () {
                    ref.refresh(
                        fetchTweetAlongUserData(notification.data!.tweetId!));
                  });
            },
            builder: (tweetData, ref, child) {
              return _NotificationListTile(
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
              );
            },
            watchThisProvider:
                fetchTweetAlongUserData(notification.data!.tweetId!),
            logger: logger);

      case FirehoseNotificationType.streams:
        return ProviderStateBuilder<YoutubeChannelData>(
            loadingBuilder: () => LoadingListTile(
                  height: 50,
                ),
            errorBuilder: (e, stk) {
              return FirehoseErrorTile(
                  notification: notification,
                  onRefesh: () {
                    ref.refresh(
                        fetchTweetAlongUserData(notification.data!.channelId!));
                  });
            },
            builder: (channelData, ref, child) {
              return _NotificationListTile(
                notification: notification,
                title: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: channelData.name,
                        style: titleStyle,
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: NumberFormat.compact()
                            .format(channelData.subcribersCount),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                body: notification.body,
                imageUrl: notification.data!.image,
              );
            },
            watchThisProvider:
                fetchYoutubeChannelDataProvider(notification.data!.channelId!),
            logger: logger);

      case FirehoseNotificationType.live_on_patrol:
        return _NotificationListTile(
          notification: notification,
          title: Text(
            notification.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          body: notification.body,
          imageUrl: notification.data!.image,
        );
      default:
        return _NotificationListTile(
          notification: notification,
          title: Text(
            notification.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
          body: notification.body,
          imageUrl: notification.data!.image,
        );
    }
  }
}

class NotificationTrailing extends StatelessWidget {
  const NotificationTrailing({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        NotificationTrailingIcon(
          notification: notification,
        ),
        Spacer(),
        Text(
          elapsedTimeForDate(notification.createdAt),
          style: TextStyle(
            color: primaryColor.shade300,
          ),
        ),
      ],
    );
  }
}

class NotificationTrailingIcon extends StatelessWidget {
  const NotificationTrailingIcon({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  @override
  Widget build(BuildContext context) {
    switch (getFirehoseNotificationTypeFromString(notification.type)) {
      case FirehoseNotificationType.twitter:
        return SvgPicture.asset(
          "assets/icon/twitter.svg",
          height: kIconSizeMediumConstant,
        );

      case FirehoseNotificationType.streams:
        return Icon(
          Icons.play_arrow_rounded,
          color: Colors.red,
        );

      case FirehoseNotificationType.live_on_patrol:
        return ShaderMask(
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kItemsSpacingMediumConstant,
      ),
      child: ListTile(
        tileColor: Color.fromARGB(255, 94, 94, 94),
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
            "Failed to load!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        trailing: NotificationTrailing(notification: notification),
      ),
    );
  }
}

class _NotificationListTile extends StatelessWidget {
  const _NotificationListTile({
    Key? key,
    required this.notification,
    required this.title,
    required this.body,
    required this.imageUrl,
    this.leading,
  }) : super(key: key);

  final ChaseAppNotification notification;
  final Widget title;

  final String body;
  final String? imageUrl;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kItemsSpacingMediumConstant,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusStandard),
        ),
        onTap: () {
          notificationHandler(
            context,
            notification,
          );
        },
        isThreeLine: true,
        tileColor: Color.fromARGB(255, 94, 94, 94),
        leading: Hero(
            tag: notification.id ?? "NA",
            child: leading ??
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(imageUrl ?? defaultPhotoURL),
                  backgroundColor: Colors.white,
                )),
        title: title,
        subtitle: Text(
          body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        trailing: NotificationTrailing(notification: notification),
      ),
    );
  }
}

class LoadingListTile extends StatefulWidget {
  const LoadingListTile({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kItemsSpacingMediumConstant,
      ),
      child: AnimatedBuilder(
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
              height: widget.height,
            );
          }),
    );
  }
}
