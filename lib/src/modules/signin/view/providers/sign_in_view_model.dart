import 'package:chaseapp/src/shared/enums/view_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInProvider =
    StateNotifierProvider<SignInViewModelStateNotifier, ViewState>(
        (ref) => SignInViewModelStateNotifier());

class SignInViewModelStateNotifier extends StateNotifier<ViewState> {
  SignInViewModelStateNotifier() : super(ViewState.Idle);

  // set state(ViewState viewState) {
  //   if (kDebugMode) {
  //     print('State:$viewState');
  //   }
  //   state = viewState;
  // }

  void update() {
    state = ViewState.Busy;
  }

  // bool _userLoginAutoValidate = false;

  // TextEditingController _passwordController = TextEditingController();

  // TextEditingController _userIdController = TextEditingController();

  // bool _passwordVisible = false;

  // bool get passwordVisible => _passwordVisible;

  // set passwordVisible(bool value) {
  //   _passwordVisible = value;
  // }

  // TextEditingController get userIdController => _userIdController;

  // set userIdController(TextEditingController value) {
  //   _userIdController = value;
  // }

  // TextEditingController get passwordController => _passwordController;

  // set passwordController(TextEditingController value) {
  //   _passwordController = value;
  // }

  // bool get userLoginAutoValidate => _userLoginAutoValidate;
  // set userLoginAutoValidate(bool value) {
  //   _userLoginAutoValidate = value;
  // }

  // clearAllModels() {
  //   _passwordController = TextEditingController();
  //   _userIdController = TextEditingController();
  //   _passwordVisible = false;
  // }
}
