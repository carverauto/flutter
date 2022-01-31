import 'dart:io';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/login_state/login_state.dart';
import 'package:chaseapp/src/modules/signin/view/parts/multi_auth_dialog.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInView extends ConsumerWidget {
  LogInView({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LogInState>(signInProvider, (oldState, newState) {
      newState.when(
          data: () {},
          multiAuth: (authProviders, credentials) async {
            final SIGNINMETHOD? knownAuthProvider =
                await showDialog<SIGNINMETHOD?>(
                    context: context,
                    builder: (context) {
                      return MultiAuthDialog(existingProviders: authProviders);
                    });

            if (knownAuthProvider != null) {
              ref
                  .read(signInProvider.notifier)
                  .handleMutliProviderSignIn(knownAuthProvider, credentials);
            }
          },
          loading: () {},
          error: (e, stk) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          });
    });
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Consumer(builder: (context, ref, _) {
              final state = ref.watch(signInProvider);
              return state.maybeWhen(loading: () {
                return const LinearProgressIndicator();
              }, orElse: () {
                return SizedBox.shrink();
              });
            }),
          ),
          Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                style: styleFrom,
                onPressed: () {
                  ref.read(signInProvider.notifier).signIn(SIGNINMETHOD.GOOGLE);
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
                    ref
                        .read(signInProvider.notifier)
                        .signIn(SIGNINMETHOD.APPLE);
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
                  ref
                      .read(signInProvider.notifier)
                      .signIn(SIGNINMETHOD.FACEBOOK);
                },
                child: Text("Continue With Facebook"),
              ),
              SizedBox(
                height: kItemsSpacingSmall,
              ),
              ElevatedButton(
                style: styleFrom,
                onPressed: () {
                  ref
                      .read(signInProvider.notifier)
                      .signIn(SIGNINMETHOD.TWITTER);
                },
                child: Text("Continue With Twitter"),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
