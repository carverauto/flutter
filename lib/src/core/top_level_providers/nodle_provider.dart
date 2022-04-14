import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/enums/nodle_state.dart';
import '../notifiers/nodel_state_notifier.dart';

final StateNotifierProvider<NodelStateNotifier, NodleState> nodleProvider =
    StateNotifierProvider<NodelStateNotifier, NodleState>(
  (StateNotifierProviderRef<NodelStateNotifier, NodleState> ref) =>
      NodelStateNotifier(),
);
