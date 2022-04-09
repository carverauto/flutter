import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as feed;

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

  final Reader read;

  final String chaseId;

  bool isSubscribed = false;

  final Logger logger = Logger('ChaseEventsStateNotifier');

  late final feed.Subscription feedSubscription;

  final feed.StreamFeedClient streamFeedClient;

  feed.FlatFeed get firehoseFeed =>
      streamFeedClient.flatFeed('events', 'animation');

  Future<List<ChaseAnimationEvent>> fetchAnimationEvents() async {
    // state = const AsyncValue.loading();
    // //  final feed.Filter filter = feed.Filter().;
    final String? videoId = read(playingVideoIdProvider);
    try {
      final List<feed.Activity> activities = await firehoseFeed.getActivities(
          // filter: filter,
          // ranking:
          );

      //convert to ChaseAnimationEvents objects
      // state = ChaseAnimationEvents list;
      final List<feed.Activity> filteredActivities =
          activities.where((feed.Activity event) {
        return event.object == 'animation-event' &&
            event.extraData?['videoId'] == videoId;
      }).toList();
      final List<ChaseAnimationEvent> chaseAnimationEvents =
          filteredActivities.map<ChaseAnimationEvent>((feed.Activity event) {
        final Map<String, Object?>? extraData = event.extraData;
        extraData!['id'] = event.id;
        final ChaseAnimationEvent animationevent =
            ChaseAnimationEvent.fromJson(extraData);

        return animationevent;
      }).toList();

      return chaseAnimationEvents;
    } catch (e, stk) {
      logger.warning('Failed to fetch Animation events for a chase', e, stk);
    }

    return [];

    // fakeAnimationEvents.sort(
    //   (ChaseAnimationEvent a, ChaseAnimationEvent b) =>
    //       a.label.compareTo(b.label),
    // );

    // return fakeAnimationEvents;
  }

  Future<void> subscribeToEventsStream() async {
    final Chase chase = await read(streamChaseProvider(chaseId).future);
    if (chase.live ?? false) {
      feedSubscription = await firehoseFeed.subscribe(
        (feed.RealtimeMessage<Object?, Object?, Object?, Object?>? message) {
          //parsed chaseapp event
          log(
            'Subcription Event ---> GetStream Feed Activity Recieved : ${message?.newActivities?.length}',
          );
          if (message?.newActivities != null) {
            final feed
                    .GenericEnrichedActivity<Object?, Object?, Object?, Object?>
                event = message!.newActivities![0];
            if (event.object == 'animation-event') {
              final Map<String, Object?>? extraData = event.extraData;
              extraData!['id'] = event.verb?.replaceFirst('event-', '');
              extraData['createdAt'] = event.time?.millisecondsSinceEpoch;
              //TODO
              // extraData['alignment'] = 'center';
              // extraData['animstate'] = 'Horse Fist';
              final ChaseAnimationEvent animationevent =
                  ChaseAnimationEvent.fromJson(extraData);
              final String? videoId = read(playingVideoIdProvider);
              final String chaseId = chase.id;

              if (animationevent.id == chaseId &&
                  animationevent.videoId == videoId) {
                if (animationevent.animtype == AnimType.pop_up) {
                  read(popupsEvetnsStreamControllerProvider)
                      .add(animationevent);
                } else if (animationevent.animtype == AnimType.theater) {
                  read(theaterEvetnsStreamControllerProvider)
                      .add(animationevent);
                } else {
                  logger.warning('Animation Event type not identified');
                }
              }
            }
          }
        },
      );

      isSubscribed = true;
    }
  }

  void unsubscribeFeed() {
    if (isSubscribed) {
      feedSubscription.cancel();
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
