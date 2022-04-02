import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../../../../shared/enums/animtype.dart';
import '../providers/providers.dart';

class ChaseEventsNotifier extends StateNotifier<AsyncValue<void>> {
  ChaseEventsNotifier({
    required this.chaseId,
    required this.read,
    required this.streamFeedClient,
  }) : super(const AsyncValue.data(null));

  @override
  void dispose() {
    if (isSubscribed) {
      feedSubscription.cancel();
    }
    super.dispose();
  }

  final Reader read;

  final String chaseId;

  bool isSubscribed = false;

  late final feed.Subscription feedSubscription;

  final feed.StreamFeedClient streamFeedClient;

  feed.FlatFeed get firehoseFeed =>
      streamFeedClient.flatFeed('events', chaseId);

  Future<List<ChaseAnimationEvent>> fetchAnimationEvents() async {
    // state = const AsyncValue.loading();
    // //  final feed.Filter filter = feed.Filter().;
    // try {
    //   // final List<feed.Activity> activities = await firehoseFeed.getActivities(
    //   //     // filter: filter,
    //   //     // ranking:
    //   //     );
    //   await subscribeToEventsStream();
    //   //convert to ChaseAnimationEvents objects
    //   // state = ChaseAnimationEvents list;
    //   state = AsyncValue.data(fakeAnimationEvents);
    // } catch (e, stk) {
    //   state = AsyncValue.error(e, stackTrace: stk);
    // }

    await Future<void>.delayed(const Duration(seconds: 5));
    fakeAnimationEvents.sort(
      (ChaseAnimationEvent a, ChaseAnimationEvent b) =>
          a.label.compareTo(b.label),
    );

    return fakeAnimationEvents;
  }

  Future<void> subscribeToEventsStream() async {
    final Chase chase = await read(streamChaseProvider(chaseId).future);
    if (chase.live ?? false) {
      feedSubscription = await firehoseFeed.subscribe(
        (feed.RealtimeMessage<Object?, Object?, Object?, Object?>? message) {
          //parsed chaseapp event
          if (message?.newActivities != null) {
            final feed
                    .GenericEnrichedActivity<Object?, Object?, Object?, Object?>
                event = message!.newActivities![0];
            if (event.object == 'animation-event') {
              final Map<String, Object?>? extraData = event.extraData;
              extraData!['id'] = event.id!;
              final ChaseAnimationEvent animationevent =
                  ChaseAnimationEvent.fromJson(extraData);

              if (animationevent.animtype == AnimType.pop_up) {
                read(popupsEvetnsStreamControllerProvider).add(animationevent);
              } else if (animationevent.animtype == AnimType.theater) {
                read(theaterEvetnsStreamControllerProvider).add(animationevent);
              } else {
                log('Event type not identified');
              }
            }
          }
        },
      );
      isSubscribed = true;
    }
  }
}

final List<ChaseAnimationEvent> fakeAnimationEvents = List.generate(
  10,
  (int index) => ChaseAnimationEvent(
    id: 'awdaw',
    animtype: AnimType.pop_up,
    endpoint: 'assets/rive/rives_animated_emojis.riv',
    animstate: '',
    label: index * 5000,
    videoId: 'videoId',
    artboard: 'love',
    animations: ['Animation 1'],
    createdAt: DateTime.now(),
    alignment: Alignment.bottomRight,
  ),
);
