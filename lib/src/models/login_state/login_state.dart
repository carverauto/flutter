import 'package:chaseapp/src/models/api_exception/api_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LogInState with _$LogInState {
  const factory LogInState.data() = _Data;
  const factory LogInState.multiAuth(
          List<String> existingAuthProviers, AuthCredential authCredential) =
      _MultiAuth;
  const factory LogInState.loading() = _Loading;
  const factory LogInState.error(ChaseAppCallException e, [StackTrace? stk]) =
      _Error;
}
