import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/api_exception/api_exception.dart';
import 'package:chaseapp/src/models/login_state/login_state.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class SignInViewModelStateNotifier extends StateNotifier<LogInState> {
  SignInViewModelStateNotifier({
    required this.read,
  }) : super(LogInState.data());

  final Reader read;

  final Logger logger = Logger("LogInView");

  Future<void> signIn(SIGNINMETHOD signinmethod) async {
    state = LogInState.loading();

    try {
      await signInUser(signinmethod);
      state = LogInState.data();
    } on FirebaseAuthException catch (e, stk) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          List<String> existingAuthProviers = await read(firebaseAuthProvider)
              .fetchSignInMethodsForEmail(e.email!);

          state = LogInState.multiAuth(existingAuthProviers, e.credential!);

          break;
        default:
          final exception = ChaseAppCallException(
            message: e.code.replaceAll("-", " ").toUpperCase(),
            error: e,
            stackTrace: stk,
          );
          state = LogInState.error(exception, stk);
      }
    } catch (e, stk) {
      logger.severe("Error signing in", e, stk);
      final exception = ChaseAppCallException(
        message: "Something went wrong. Please try again.",
        error: e,
        stackTrace: stk,
      );
      state = LogInState.error(exception, stk);
    }
  }

  Future<void> signInUser(SIGNINMETHOD signinmethod) async {
    await read(authRepoProvider).socialLogin(signinmethod);
  }

  Future<void> handleMutliProviderSignIn(
      SIGNINMETHOD knownAuthProvider, AuthCredential credential) async {
    state = LogInState.loading();
    await read(authRepoProvider)
        .handleMutliProviderSignIn(knownAuthProvider, credential);

    if (mounted) {
      state = LogInState.data();
    }
  }
}
