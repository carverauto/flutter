import 'package:chaseapp/src/notifiers/nodel_state_notifier.dart';
import 'package:chaseapp/src/shared/enums/nodle_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nodleProvider = StateNotifierProvider<NodelStateNotifier, NodleState>(
    (ref) => NodelStateNotifier());
