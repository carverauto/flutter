import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';

class ChaseEventsNotifier extends StateNotifier<AsyncValue<void>> {
  ChaseEventsNotifier({
    required this.chaseId,
    required this.read,
    required this.streamFeedClient,
  }) : super(const AsyncValue.data(null));

  final Reader read;

  final String chaseId;

  // late String videoId;

  final feed.StreamFeedClient streamFeedClient;

  final StreamController<ChaseAnimationEvent> streamController =
      StreamController<ChaseAnimationEvent>();

  // late List<ChaseAnimationEvent> _animationEvents;

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
      final feed.Subscription subscription = await firehoseFeed.subscribe(
        (feed.RealtimeMessage<Object?, Object?, Object?, Object?>? message) {
          //parsed chaseapp event
          final ChaseAnimationEvent animationevent = ChaseAnimationEvent(
            id: 'awdaw',
            animtype: 'pop_up',
            endpoint: 'assets/rive/rives_animated_emojis.riv',
            animstate: '',
            label: 10000,
            videoId: 'videoId',
            artboard: 'love',
            animation: 'Animation 1',
            createdAt: DateTime.now(),
            alignment: Alignment.bottomRight,
          );

          streamController.add(animationevent);
        },
      );
    }
  }
}

final List<ChaseAnimationEvent> fakeAnimationEvents = List.generate(
  10,
  (int index) => ChaseAnimationEvent(
    id: 'awdaw',
    animtype: 'pop_up',
    endpoint: 'assets/rive/rives_animated_emojis.riv',
    animstate: '',
    label: index * 5000,
    videoId: 'videoId',
    artboard: 'love',
    animation: 'Animation 1',
    createdAt: DateTime.now(),
    alignment: Alignment.bottomRight,
  ),
);
