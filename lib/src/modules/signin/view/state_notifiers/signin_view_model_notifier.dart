import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../models/api_exception/api_exception.dart';
import '../../../../models/login_state/login_state.dart';
import '../../../../shared/enums/social_logins.dart';

class SignInViewModelStateNotifier extends StateNotifier<LogInState> {
  SignInViewModelStateNotifier({
    required this.read,
  }) : super(const LogInState.data());

  final Reader read;

  final Logger logger = Logger('LogInView');

  Future<void> signIn(SIGNINMETHOD signinmethod) async {
    state = const LogInState.loading();

    try {
      await signInUser(signinmethod);
      state = const LogInState.data();
    } on FirebaseAuthException catch (e, stk) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          final List<String> existingAuthProviers =
              await read(firebaseAuthProvider)
                  .fetchSignInMethodsForEmail(e.email!);

          state = LogInState.multiAuth(existingAuthProviers, e.credential!);

          break;
        default:
          final ChaseAppCallException exception = ChaseAppCallException(
            message: e.code.replaceAll('-', ' ').toUpperCase(),
            error: e,
            //    stackTrace: stk,
          );
          logger.severe(exception.message, e, stk);
          state = LogInState.error(exception, stk);
      }
    } catch (e, stk) {
      logger.severe('Error signing in', e, stk);
      final ChaseAppCallException exception = ChaseAppCallException(
        message: 'Something went wrong. Please try again.',
        error: e,
        //   stackTrace: stk,
      );
      state = LogInState.error(exception, stk);
    }
  }

  Future<void> signInUser(SIGNINMETHOD signinmethod) async {
    await read(authRepoProvider).socialLogin(signinmethod);
  }

  Future<void> sendSignInLinkToEmail(String email) async {
    await read(authRepoProvider).sendSignInLinkToEmail(email);
  }

  Future<void> signInWithEmail(String email, String link) async {
    state = const LogInState.loading();

    try {
      await read(authRepoProvider).signInWithEmailAndLink(email, link);

      state = const LogInState.data();
    } on FirebaseAuthException catch (e, stk) {
      final ChaseAppCallException exception = ChaseAppCallException(
        message: e.code.replaceAll('-', ' ').toUpperCase(),
        error: e,
        // stackTrace: stk,
      );
      logger.severe(exception.message, e, stk);
      state = LogInState.error(exception, stk);
    } catch (e, stk) {
      logger.severe('Error signing in', e, stk);
      final ChaseAppCallException exception = ChaseAppCallException(
        message: 'Something went wrong. Please try again.',
        error: e,
        //  stackTrace: stk,
      );
      state = LogInState.error(exception, stk);
    }
  }

  Future<void> handleMutliProviderSignIn(
    SIGNINMETHOD knownAuthProvider,
    AuthCredential credential,
  ) async {
    state = const LogInState.loading();
    try {
      await read(authRepoProvider)
          .handleMutliProviderSignIn(knownAuthProvider, credential);
    } catch (e, stk) {
      logger.severe('Error occured while handling MutliProviderSignIn', e, stk);
      if (mounted) {
        state = const LogInState.data();
      }
    }
  }
}
