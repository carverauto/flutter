import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chaseapp/src/const/other.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/login_state/login_state.dart';
import 'package:chaseapp/src/modules/signin/view/parts/button_scale_transition.dart';
import 'package:chaseapp/src/modules/signin/view/parts/email_signin_bottom.dart';
import 'package:chaseapp/src/modules/signin/view/parts/gradient_animation_container.dart';
import 'package:chaseapp/src/modules/signin/view/parts/login_footer.dart';
import 'package:chaseapp/src/modules/signin/view/parts/multi_auth_dialog.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
  SIGNINMETHOD? signinmethod = null;
  bool isLoggingWithEmail = false;
  String? emailAddress;
  AuthCredential? authCredential;
  final TextEditingController _textEditingController = TextEditingController();

  final FocusScopeNode focusScopeNode = FocusScopeNode();

  List<SIGNINMETHOD> get socialSigninMethods => [
        SIGNINMETHOD.Google,
        SIGNINMETHOD.Apple,
        SIGNINMETHOD.Facebook,
        SIGNINMETHOD.Twitter,
        SIGNINMETHOD.Email,
      ];

  void requestFocusForEmail() {
    setState(() {
      isLoggingWithEmail = true;

      Timer(Duration(milliseconds: 300), () {
        if (focusScopeNode.canRequestFocus) {
          focusScopeNode.requestFocus();
        }
      });
    });
  }

  void signInWith(SIGNINMETHOD method) async {
    setState(() {
      signinmethod = method;
    });
    ref.read(signInProvider.notifier).signIn(method);
  }

  void logInuser(String link) async {
    if (emailAddress != null) {
      setState(() {
        signinmethod = SIGNINMETHOD.Email;
      });
      await Future<void>.delayed(Duration(seconds: 5));
      await ref
          .read(signInProvider.notifier)
          .signInWithEmail(emailAddress!, link);

      if (authCredential != null) {
        await ref
            .read(firebaseAuthProvider)
            .currentUser!
            .linkWithCredential(authCredential!);
      }
    }
  }

  void handleDynamicLinkFromTerminatedState() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.path == "/__/auth/action") {
        logInuser(deepLink.toString());
      }
    }
  }

  void handleDynamicLinkOpenedFromBackgroundState() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        if (deepLink.path == "/__/auth/action") {
          logInuser(deepLink.toString());
        }
      }
    }, onError: (Object error, StackTrace stackTrace) {
      log("Error while recieving dynamic link", error: error);
    });
  }

  @override
  void initState() {
    super.initState();
    handleDynamicLinkFromTerminatedState();
    handleDynamicLinkOpenedFromBackgroundState();
  }

  @override
  void dispose() {
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
            setState(() {
              authCredential = credentials;
            });
            final SIGNINMETHOD? knownAuthProvider =
                await showDialog<SIGNINMETHOD?>(
                    context: context,
                    builder: (context) {
                      return MultiAuthDialog(existingProviders: authProviders);
                    });

            if (knownAuthProvider != null) {
              if (knownAuthProvider != SIGNINMETHOD.Email) {
                ref
                    .read(signInProvider.notifier)
                    .handleMutliProviderSignIn(knownAuthProvider, credentials);
              } else {
                setState(() {
                  signinmethod = null;
                  isLoggingWithEmail = true;
                });
              }
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
                    if (isLoggingWithEmail && signinmethod == null)
                      Text(
                        "Continue with your Email",
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline4!.fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ...socialSigninMethods.map((method) {
                      if (method == SIGNINMETHOD.Apple && Platform.isAndroid) {
                        return SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: kItemsSpacingSmall),
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: signinmethod != null
                              ?
                              //  method != SIGNINMETHOD.Email
                              //     ?
                              method == signinmethod
                                  ? 1
                                  : 0
                              // : 0
                              : isLoggingWithEmail
                                  ? method == SIGNINMETHOD.Email
                                      ? 1
                                      : 0
                                  : 1,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: kPrimaryCurve,
                            height: signinmethod != null
                                ?
                                //  method != SIGNINMETHOD.Email
                                //     ?
                                method == signinmethod
                                    ? 50
                                    : 0
                                // : 0
                                : isLoggingWithEmail
                                    ? method == SIGNINMETHOD.Email
                                        ? 50
                                        : 0
                                    : 50,
                            child: ButtonScaleAnimationWidget(
                              child: GradientAnimationChildBuilder(
                                shouldAnimate:
                                    // signinmethod != SIGNINMETHOD.Email
                                    //     ?
                                    signinmethod == method,
                                // : isLoggingWithEmail,
                                child: ElevatedButton.icon(
                                  icon: IconFloatingAnimation(
                                    child: method == SIGNINMETHOD.Email
                                        ? Icon(Icons.email)
                                        : SvgPicture.asset(
                                            method.getAssetIcon,
                                            height: kIconSizeLargeConstant,
                                          ),
                                    shouldAnimate:
                                        // signinmethod != SIGNINMETHOD.Email
                                        //     ?
                                        signinmethod == method,
                                    // : isLoggingWithEmail,
                                  ),
                                  style: callToActionButtonStyle,
                                  onPressed: () {
                                    if (method != SIGNINMETHOD.Email) {
                                      signInWith(method);
                                    } else {
                                      requestFocusForEmail();
                                    }
                                  },
                                  label:
                                      //  isLoggingWithEmail
                                      //     ? Text(
                                      //         signinmethod == method
                                      //             ? ""
                                      //             : "Continue With ${method.name}",
                                      //         style: getButtonStyle(context),
                                      //       )
                                      //     :
                                      AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    child: isLoggingWithEmail &&
                                            signinmethod == null &&
                                            method == SIGNINMETHOD.Email
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 2,
                                            ),
                                            child: TextField(
                                              controller:
                                                  _textEditingController,
                                              focusNode: focusScopeNode,
                                              cursorColor: Colors.white,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              decoration: InputDecoration(
                                                hintText: "Enter",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            signinmethod == method
                                                ? ""
                                                : "Continue With ${method.name}",
                                            style: getButtonStyle(context),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            EmailSignInBottom(
                textEditingController: _textEditingController,
                isLoggingInWithEmail: signinmethod == SIGNINMETHOD.Email,
                onTap: () async {
                  setState(() {
                    emailAddress = _textEditingController.text;
                  });
                  await ref
                      .read(signInProvider.notifier)
                      .sendSignInLinkToEmail(emailAddress!);
                }),
            Spacer(),
            LogInFooter(
                isLoggingWithEmail: isLoggingWithEmail,
                isEmailSignInMethod: signinmethod == SIGNINMETHOD.Email,
                onTap: () {
                  setState(() {
                    focusScopeNode.unfocus();
                    _textEditingController.clear();
                    isLoggingWithEmail = false;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
