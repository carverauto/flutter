import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/user/user_data.dart';
import '../../../../shared/notifications/activity_to_notification_convertor.dart';
import '../../../chats/view/providers/providers.dart';

class FirehoseStateNotifier extends StateNotifier<void> {
  FirehoseStateNotifier({
    required this.read,
    required this.streamFeedClient,
  }) : super(null);

  final Reader read;
  final feed.StreamFeedClient streamFeedClient;

  final Logger logger = Logger('FirehoseServiceStateNotifier');

  late final String userToken;

  bool isSubscribedToFeed = false;

  late feed.Subscription firehoseSubscription;

  feed.FlatFeed get firehoseFeed =>
      streamFeedClient.flatFeed('events', 'firehose');

  feed.StreamFeedClient get streamFeed => streamFeedClient;

  @override
  void dispose() {
    if (isSubscribedToFeed) {
      firehoseSubscription.cancel();
    }
    super.dispose();
  }

  Future<void> setUserAndSubscribe() async {
    if (streamFeedClient.currentUser == null) {
      final UserData userData = await read(userStreamProvider.future);
      final String userToken =
          await read(chatsRepoProvider).getUserToken(userData.uid);
      await streamFeedClient.setUser(
        feed.User(
          id: userData.uid,
        ),
        feed.Token(userToken),
      );
    }
    await subscribeToFeed();
  }

  Future<List<ChaseAppNotification>> fetchFirehoseFeed(int offset) async {
    await setUserAndSubscribe();

    final List<feed.Activity> activities =
        await firehoseFeed.getActivities(limit: 20, offset: offset);

    return activities.map(convertActivityToChaseAppNotification).toList();
  }

  Future<void> subscribeToFeed() async {
    if (!isSubscribedToFeed) {
      firehoseSubscription = await firehoseFeed.subscribe(
        (feed.RealtimeMessage<Object?, Object?, Object?, Object?>? message) {},
      );
      isSubscribedToFeed = true;
    }
  }
}
