import 'package:chaseapp/src/models/login_state/login_state.dart';
import 'package:chaseapp/src/modules/signin/view/state_notifiers/signin_view_model_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInProvider =
    StateNotifierProvider.autoDispose<SignInViewModelStateNotifier, LogInState>(
        (ref) => SignInViewModelStateNotifier(read: ref.read));
