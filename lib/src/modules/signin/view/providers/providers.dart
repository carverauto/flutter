import 'package:chaseapp/src/modules/signin/view/state_notifiers/signin_view_model_notifier.dart';
import 'package:chaseapp/src/shared/enums/view_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInProvider =
    StateNotifierProvider<SignInViewModelStateNotifier, ViewState>(
        (ref) => SignInViewModelStateNotifier());
