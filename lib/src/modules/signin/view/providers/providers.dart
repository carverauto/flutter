import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/login_state/login_state.dart';
import '../state_notifiers/signin_view_model_notifier.dart';

final AutoDisposeStateNotifierProvider<SignInViewModelStateNotifier, LogInState>
    signInProvider =
    StateNotifierProvider.autoDispose<SignInViewModelStateNotifier, LogInState>(
  (
    AutoDisposeStateNotifierProviderRef<SignInViewModelStateNotifier,
            LogInState>
        ref,
  ) =>
      SignInViewModelStateNotifier(ref: ref),
);
