import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/chase_animation_event.dart/chase_animation_event.dart';
import '../../../chats/view/providers/providers.dart';
import '../notifiers/chase_events_notifier.dart';

final AutoDisposeStreamProviderFamily<Chase, String> streamChaseProvider =
    StreamProvider.autoDispose.family<Chase, String>(
  (AutoDisposeStreamProviderRef<Chase> ref, String chaseId) {
    ref.onDispose(() async {
      ref.read(chaseEventsNotifierProvider(chaseId).notifier).unsubscribeFeed();
      ref.refresh(chaseEventsNotifierProvider(chaseId));

      await ref.read(popupsEvetnsStreamControllerProvider).close();
      await ref.read(theaterEvetnsStreamControllerProvider).close();

      final bool isChannelInitialized =
          await ref.read(chatChannelProvider(chaseId)).initialized;
      if (isChannelInitialized) {
        await ref.read(chatChannelProvider(chaseId)).stopWatching();
      }

      // await ref.read(streamChatClientProvider).disconnectUser();
    });

    return ref.watch(chaseRepoProvider).streamChase(chaseId);
  },
);

// final chaseDetailsHeightProvider = StateProvider<double?>((ref) => null);
final AutoDisposeStateProvider<bool> playVideoProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);
final AutoDisposeStateProvider<bool> showVideoOverlayProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => true,
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
