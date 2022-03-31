import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/chase/chase.dart';
import '../../../chats/view/providers/providers.dart';
import '../notifiers/chase_events_notifier.dart';

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

// final  StateNotifierProviderFamily<StateNotifierProvider<ChaseEventsNotifier, void>, List<ChaseAnimationEvent>, Chase> chasesEventsStateNotifierProvider = StateNotifierProvider.family<StateNotifierProvider<ChaseEventsNotifier, void> ,List<ChaseAnimationEvent>,Chase>((StateNotifierProvider<ChaseEventsNotifier, void> ref,Chase chase ) {
//   return
// });

final StateNotifierProviderFamily<ChaseEventsNotifier, void, Chase>
    chaseEventsNotifierProvider =
    StateNotifierProvider.family<ChaseEventsNotifier, void, Chase>(
  (StateNotifierProviderRef<ChaseEventsNotifier, void> ref, Chase chase) =>
      ChaseEventsNotifier(
    chase: chase,
    read: ref.read,
    streamFeedClient: ref.read(streamFeedClientProvider),
  ),
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
