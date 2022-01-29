import 'dart:developer';
import 'dart:io';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/enums/view_state.dart';
import 'package:chaseapp/src/shared/util/helpers/multi_provider_helper.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class LogInView extends ConsumerWidget {
  LogInView({Key? key}) : super(key: key);

  final Logger logger = Logger("LogInView");

  Future<void> signIn(
      Reader read, BuildContext context, SIGNINMETHOD signinmethod) async {
    read(signInProvider.notifier).state = ViewState.Busy;
    try {
      //TODO:Loading State and call for login should go in SignInNotifer

      await read(authRepoProvider).socialLogin(signinmethod);
      read(signInProvider.notifier).state = ViewState.Idle;
    } on FirebaseAuthException catch (e) {
      read(signInProvider.notifier).state = ViewState.Idle;

      switch (e.code) {
        case "account-exists-with-different-credential":
          List<String> signInlist = await read(firebaseAuthProvider)
              .fetchSignInMethodsForEmail(e.email!);

          final SIGNINMETHOD? knownAuthProvider =
              await showDialog<SIGNINMETHOD?>(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.all(kPaddingMediumConstant),
                      child: Padding(
                        padding: EdgeInsets.all(kPaddingSmallConstant),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Account already created with different Provider. Please sign in with the provider you used to create the account at first. This will link your account with the provider you are currently using.",
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: kItemsSpacingSmall,
                            ),
                            Wrap(
                              children: signInlist.map<Widget>((provider) {
                                final SIGNINMETHOD knownAuthProvider =
                                    getSignInProviderHelper(provider);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, knownAuthProvider);
                                    },
                                    child: Text(knownAuthProvider.name),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  });

          if (knownAuthProvider != null) {
            try {
              await read(authRepoProvider)
                  .handleMutliProviderSignIn(knownAuthProvider, e.credential!);
            } catch (e, stk) {
              logger.severe("Error while logging User.", e, stk);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Error logging in with $knownAuthProvider. Please try again."),
              ));
            }
          }

          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.code.replaceAll("-", " ").toUpperCase()),
          ));
          break;
      }
    } catch (e, stk) {
      logger.severe("Error while logging User.", e, stk);
      read(signInProvider.notifier).state = ViewState.Idle;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styleFrom = OutlinedButton.styleFrom(
      maximumSize: Size(
        Sizescaleconfig.screenwidth! * 0.6,
        50,
      ),
      minimumSize: Size(
        Sizescaleconfig.screenwidth! * 0.6,
        50,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Consumer(builder: (context, ref, _) {
                final state = ref.watch(signInProvider);
                return state == ViewState.Busy
                    ? const LinearProgressIndicator()
                    : SizedBox.shrink();
              }),
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  style: styleFrom,
                  onPressed: () {
                    signIn(
                      ref.read,
                      context,
                      SIGNINMETHOD.GOOGLE,
                    );
                  },
                  child: Text("Continue With Google"),
                ),
                SizedBox(
                  height: kItemsSpacingSmall,
                ),
                if (Platform.isIOS)
                  ElevatedButton(
                    style: styleFrom,
                    onPressed: () {
                      signIn(
                        ref.read,
                        context,
                        SIGNINMETHOD.APPLE,
                      );
                    },
                    child: Text("Continue With Apple"),
                  ),
                if (Platform.isIOS)
                  SizedBox(
                    height: kItemsSpacingSmall,
                  ),
                ElevatedButton(
                  style: styleFrom,
                  onPressed: () {
                    signIn(
                      ref.read,
                      context,
                      SIGNINMETHOD.FACEBOOK,
                    );
                  },
                  child: Text("Continue With Facebook"),
                ),
                SizedBox(
                  height: kItemsSpacingSmall,
                ),
                ElevatedButton(
                  style: styleFrom,
                  onPressed: () {
                    signIn(
                      ref.read,
                      context,
                      SIGNINMETHOD.TWITTER,
                    );
                  },
                  child: Text("Continue With Twitter"),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
