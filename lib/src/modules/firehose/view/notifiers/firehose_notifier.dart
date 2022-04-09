import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../models/notification/notification.dart';
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

  bool isUserTokenInitialized = false;

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
      final String uid = read(firebaseAuthProvider).currentUser!.uid;
      if (!isUserTokenInitialized) {
        userToken = await read(chatsRepoProvider).getUserToken(uid);
        isUserTokenInitialized = true;
      }
      await streamFeedClient.setUser(
        feed.User(
          id: uid,
        ),
        feed.Token(userToken),
      );
    }
    // ignore: unawaited_futures
    subscribeToFeed();
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
