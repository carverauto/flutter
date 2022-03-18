import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../const/colors.dart';
import '../../const/images.dart';
import '../../const/sizings.dart';
import '../../models/notification/notification.dart';
import '../../models/tweet_data/tweet_data.dart';
import '../../models/youtube_data/youtube_data.dart';
import '../../modules/firehose/view/providers/providers.dart';
import '../enums/firehose_notification_type.dart';
import '../util/helpers/date_added.dart';
import '../widgets/builders/providerStateBuilder.dart';
import 'notification_handler.dart';

class NotificationTile extends ConsumerWidget {
  NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  final Logger logger = Logger('NotificationTile');

  final TextStyle titleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirehoseNotificationType? notificationType =
        getFirehoseNotificationTypeFromString(notification.type);
    switch (notificationType) {
      case FirehoseNotificationType.twitter:
        return ProviderStateBuilder<TweetData>(
          loadingBuilder: () => const LoadingListTile(
            height: 50,
          ),
          errorBuilder: (Object e, StackTrace? stk) {
            return FirehoseErrorTile(
              notification: notification,
              onRefesh: () {
                ref.refresh(
                  fetchTweetAlongUserData(notification.data!.tweetId!),
                );
              },
            );
          },
          builder: (TweetData tweetData, WidgetRef ref, Widget? child) {
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
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: '@${tweetData.userName}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
          watchThisProvider:
              fetchTweetAlongUserData(notification.data!.tweetId!),
          logger: logger,
        );

      case FirehoseNotificationType.streams:
        return ProviderStateBuilder<YoutubeChannelData>(
          loadingBuilder: () => const LoadingListTile(
            height: 50,
          ),
          errorBuilder: (Object e, StackTrace? stk) {
            return FirehoseErrorTile(
              notification: notification,
              onRefesh: () {
                ref.refresh(
                  fetchTweetAlongUserData(notification.data!.channelId!),
                );
              },
            );
          },
          builder:
              (YoutubeChannelData channelData, WidgetRef ref, Widget? child) {
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
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: NumberFormat.compact()
                          .format(channelData.subcribersCount),
                      style: const TextStyle(color: Colors.grey),
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
          logger: logger,
        );

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
      case FirehoseNotificationType.events:
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

      case FirehoseNotificationType.chase:
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
      children: <Widget>[
        NotificationTrailingIcon(
          notification: notification,
        ),
        const Spacer(),
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

  Widget buildTrailingIcon() {
    switch (getFirehoseNotificationTypeFromString(notification.type)) {
      case FirehoseNotificationType.twitter:
        return SvgPicture.asset(
          'assets/icon/twitter.svg',
          height: kIconSizeMediumConstant,
        );

      case FirehoseNotificationType.streams:
        return const Icon(
          Icons.play_arrow_rounded,
          color: Colors.red,
        );

      case FirehoseNotificationType.live_on_patrol:
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ).createShader(bounds);
          },
          child: const Icon(
            Icons.local_police_rounded,
            color: Colors.white,
          ),
        );

      case FirehoseNotificationType.events:
        return const SizedBox.shrink();
      case FirehoseNotificationType.chase:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildTrailingIcon();
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
        tileColor: const Color.fromARGB(255, 94, 94, 94),
        title: TextButton.icon(
          onPressed: onRefesh,
          icon: IconButton(
            onPressed: onRefesh,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
          label: const Text(
            'Failed to load!',
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
        tileColor: const Color.fromARGB(255, 94, 94, 94),
        leading: Hero(
          tag: notification.id ?? UniqueKey(),
          child: leading ??
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(imageUrl ?? defaultPhotoURL),
                backgroundColor: Colors.white,
              ),
        ),
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
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusStandard),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                transform: const GradientRotation(pi / 4),
                colors: const [
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
        },
      ),
    );
  }
}
