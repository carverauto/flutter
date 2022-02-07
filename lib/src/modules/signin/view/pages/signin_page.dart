import 'dart:io';

import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/models/login_state/login_state.dart';
import 'package:chaseapp/src/modules/signin/view/parts/multi_auth_dialog.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LogInView extends ConsumerWidget {
  LogInView({Key? key}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(kPaddingMediumConstant),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      SIGNINMETHOD.GOOGLE.getAssetIcon,
                      height: kIconSizeLargeConstant,
                    ),
                    style: callToActionButtonStyle,
                    onPressed: () {
                      ref
                          .read(signInProvider.notifier)
                          .signIn(SIGNINMETHOD.GOOGLE);
                    },
                    label: Text(
                      "Continue With Google",
                      style: getButtonStyle(context),
                    ),
                  ),
                  SizedBox(
                    height: kItemsSpacingSmall,
                  ),
                  if (Platform.isIOS)
                    ElevatedButton.icon(
                      icon: SvgPicture.asset(
                        SIGNINMETHOD.APPLE.getAssetIcon,
                        height: kIconSizeLargeConstant,
                      ),
                      style: callToActionButtonStyle,
                      onPressed: () {
                        ref
                            .read(signInProvider.notifier)
                            .signIn(SIGNINMETHOD.APPLE);
                      },
                      label: Text(
                        "Continue With Apple",
                        style: getButtonStyle(context),
                      ),
                    ),
                  if (Platform.isIOS)
                    SizedBox(
                      height: kItemsSpacingSmall,
                    ),
                  ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      SIGNINMETHOD.FACEBOOK.getAssetIcon,
                      height: kIconSizeLargeConstant,
                    ),
                    style: callToActionButtonStyle,
                    onPressed: () {
                      ref
                          .read(signInProvider.notifier)
                          .signIn(SIGNINMETHOD.FACEBOOK);
                    },
                    label: Text(
                      "Continue With Facebook",
                      style: getButtonStyle(context),
                    ),
                  ),
                  SizedBox(
                    height: kItemsSpacingSmall,
                  ),
                  ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      SIGNINMETHOD.TWITTER.getAssetIcon,
                      height: kIconSizeLargeConstant,
                    ),
                    style: callToActionButtonStyle,
                    onPressed: () {
                      ref
                          .read(signInProvider.notifier)
                          .signIn(SIGNINMETHOD.TWITTER);
                    },
                    label: Text(
                      "Continue With Twitter",
                      style: getButtonStyle(context),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: "By signing in you agree to the",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                  ),
                  TextSpan(
                    text: " terms of service",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(tosPolicy);
                      },
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                  ),
                  TextSpan(
                    text: "privacy policy",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(privacyPolicy);
                      },
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
