import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase/network/chase_network.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../../../chats/view/providers/providers.dart';
import '../notifiers/chase_events_notifier.dart';

final StateProvider<String?> currentlyPlayingVideoUrlProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) {
  return null;
});
final StateProvider<bool> isPlayingAnyVideoProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final AutoDisposeStreamProviderFamily<Chase, String> streamChaseProvider =
    StreamProvider.autoDispose.family<Chase, String>(
  (AutoDisposeStreamProviderRef<Chase> ref, String chaseId) {
    ref.onDispose(() async {
      ref.read(chaseEventsNotifierProvider(chaseId).notifier).unsubscribeFeed();

      await ref.read(popupsEvetnsStreamControllerProvider).close();
      await ref.read(theaterEvetnsStreamControllerProvider).close();
    });

    return ref.watch(chaseRepoProvider).streamChase(chaseId);
  },
);

final AutoDisposeStateProviderFamily<bool, String>
    chaseLiveStatusChaseProvider =
    StateProvider.autoDispose.family<bool, String>(
  (AutoDisposeStateProviderRef<bool> ref, String chaseId) {
    return ref.watch(
      streamChaseProvider(chaseId).select((AsyncValue<Chase> value) {
        return value.value?.live ?? false;
      }),
    );
  },
);

final AutoDisposeStateProviderFamily<List<ChaseNetwork>?, String>
    chaseNetworksStateProvider =
    StateProvider.autoDispose.family<List<ChaseNetwork>?, String>(
  (AutoDisposeStateProviderRef<List<ChaseNetwork>?> ref, String chaseId) {
    return ref.watch(
      streamChaseProvider(chaseId).select((AsyncValue<Chase> value) {
        return value.value?.networks;
      }),
    );
  },
);

final AutoDisposeFutureProviderFamily<Chase, String> fetchChaseProvider =
    FutureProvider.autoDispose.family<Chase, String>(
  (AutoDisposeFutureProviderRef<Chase> ref, String chaseId) {
    ref.onDispose(() async {
      ref.read(chaseEventsNotifierProvider(chaseId).notifier).unsubscribeFeed();

      await ref.read(popupsEvetnsStreamControllerProvider).close();
      await ref.read(theaterEvetnsStreamControllerProvider).close();
    });

    return ref.watch(chaseRepoProvider).fetchChase(chaseId);
  },
);

// final chaseDetailsHeightProvider = StateProvider<double?>((ref) => null);
final StateProvider<bool> playVideoProvider = StateProvider<bool>(
  (StateProviderRef<bool> ref) => true,
);
final AutoDisposeStateProvider<bool> showVideoOverlayProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);
final AutoDisposeStateProvider<bool> isShowingChatsWindowProvide =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);

final StateProvider<String?> playingVideoIdProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);

// final  StateNotifierProviderFamily<StateNotifierProvider<ChaseEventsNotifier, void>, List<ChaseAnimationEvent>, Chase> chasesEventsStateNotifierProvider = StateNotifierProvider.family<StateNotifierProvider<ChaseEventsNotifier, void> ,List<ChaseAnimationEvent>,Chase>((StateNotifierProvider<ChaseEventsNotifier, void> ref,Chase chase ) {
//   return
// });

final StateNotifierProviderFamily<ChaseEventsNotifier, void, String>
    chaseEventsNotifierProvider =
    StateNotifierProvider.family<ChaseEventsNotifier, void, String>(
  (
    StateNotifierProviderRef<ChaseEventsNotifier, void> ref,
    String chaseId,
  ) =>
      ChaseEventsNotifier(
    chaseId: chaseId,
    read: ref.read,
    streamFeedClient: ref.read(streamFeedClientProvider),
  ),
);

final Provider<StreamController<ChaseAnimationEvent>>
    popupsEvetnsStreamControllerProvider =
    Provider<StreamController<ChaseAnimationEvent>>(
  (ProviderRef<StreamController<ChaseAnimationEvent>> ref) =>
      StreamController<ChaseAnimationEvent>(),
);
final Provider<StreamController<ChaseAnimationEvent>>
    theaterEvetnsStreamControllerProvider =
    Provider<StreamController<ChaseAnimationEvent>>(
  (ProviderRef<StreamController<ChaseAnimationEvent>> ref) =>
      StreamController<ChaseAnimationEvent>(),
);

// final FutureProviderFamily<List<ChaseAnimationEvent>, Chase>
//     fetchAllChaseEvents =
//     FutureProvider.family<List<ChaseAnimationEvent>, Chase>(
//   (FutureProviderRef<List<ChaseAnimationEvent>> ref, Chase chase) async {
//     return ref
//         .read(chatsServiceStateNotifierProvider(chase).notifier)
//         .fetchAnimationEvents();
//   },
// );
