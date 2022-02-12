import 'dart:io';
import 'dart:math';

import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/models/login_state/login_state.dart';
import 'package:chaseapp/src/modules/signin/view/parts/button_scale_transition.dart';
import 'package:chaseapp/src/modules/signin/view/parts/gradient_animation_container.dart';
import 'package:chaseapp/src/modules/signin/view/parts/multi_auth_dialog.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogInViewState();
}

class _LogInViewState extends ConsumerState<LogInView>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> rotationAnimation;

  SIGNINMETHOD? signinmethod = null;

  void signInWith(SIGNINMETHOD method) {
    setState(() {
      signinmethod = method;
    });
    ref.read(signInProvider.notifier).signIn(method);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    rotationAnimation = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.decelerate,
      ),
    );

    animationController.forward();

    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LogInState>(signInProvider, (oldState, newState) {
      newState.when(
          data: () {
            setState(() {
              signinmethod = null;
            });
          },
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
            } else {
              setState(() {
                signinmethod = null;
              });
            }
          },
          loading: () {},
          error: (e, stk) {
            setState(() {
              signinmethod = null;
            });
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
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(kPaddingMediumConstant),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    ButtonScaleAnimationWidget(
                      child: GradientAnimationChildBuilder(
                        shouldAnimate: signinmethod == SIGNINMETHOD.GOOGLE,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset(
                            SIGNINMETHOD.GOOGLE.getAssetIcon,
                            height: kIconSizeLargeConstant,
                          ),
                          style: callToActionButtonStyle,
                          onPressed: () {
                            signInWith(SIGNINMETHOD.GOOGLE);
                          },
                          label: Text(
                            "Continue With Google",
                            style: getButtonStyle(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kItemsSpacingSmall,
                    ),
                    if (Platform.isIOS)
                      ButtonScaleAnimationWidget(
                          child: GradientAnimationChildBuilder(
                        shouldAnimate: signinmethod == SIGNINMETHOD.APPLE,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset(
                            SIGNINMETHOD.APPLE.getAssetIcon,
                            height: kIconSizeLargeConstant,
                          ),
                          style: callToActionButtonStyle,
                          onPressed: () {
                            signInWith(SIGNINMETHOD.APPLE);
                          },
                          label: Text(
                            "Continue With Apple",
                            style: getButtonStyle(context),
                          ),
                        ),
                      )),
                    if (Platform.isIOS)
                      SizedBox(
                        height: kItemsSpacingSmall,
                      ),
                    ButtonScaleAnimationWidget(
                        child: GradientAnimationChildBuilder(
                      shouldAnimate: signinmethod == SIGNINMETHOD.FACEBOOK,
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          SIGNINMETHOD.FACEBOOK.getAssetIcon,
                          height: kIconSizeLargeConstant,
                        ),
                        style: callToActionButtonStyle,
                        onPressed: () {
                          signInWith(SIGNINMETHOD.FACEBOOK);
                        },
                        label: Text(
                          "Continue With Facebook",
                          style: getButtonStyle(context),
                        ),
                      ),
                    )),
                    SizedBox(
                      height: kItemsSpacingSmall,
                    ),
                    ButtonScaleAnimationWidget(
                        child: GradientAnimationChildBuilder(
                      shouldAnimate: signinmethod == SIGNINMETHOD.TWITTER,
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          SIGNINMETHOD.TWITTER.getAssetIcon,
                          height: kIconSizeLargeConstant,
                        ),
                        style: callToActionButtonStyle,
                        onPressed: () {
                          signInWith(SIGNINMETHOD.TWITTER);
                        },
                        label: Text(
                          "Continue With Twitter",
                          style: getButtonStyle(context),
                        ),
                      ),
                    )),
                  ],
                ),
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
