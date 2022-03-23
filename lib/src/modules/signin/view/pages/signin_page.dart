import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../const/other.dart';
import '../../../../const/sizings.dart';
import '../../../../const/textstyles.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../models/api_exception/api_exception.dart';
import '../../../../models/login_state/login_state.dart';
import '../../../../shared/enums/social_logins.dart';
import '../parts/button_scale_transition.dart';
import '../parts/email_signin_bottom.dart';
import '../parts/gradient_animation_container.dart';
import '../parts/login_footer.dart';
import '../parts/multi_auth_dialog.dart';
import '../providers/providers.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogInViewState();
}

class _LogInViewState extends ConsumerState<LogInView>
    with SingleTickerProviderStateMixin {
  SIGNINMETHOD? signinmethod;
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

      Timer(const Duration(milliseconds: 300), () {
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
    await ref.read(signInProvider.notifier).signIn(method);
  }

  void logInuser(String link) async {
    if (emailAddress != null) {
      setState(() {
        signinmethod = SIGNINMETHOD.Email;
      });
      await Future<void>.delayed(const Duration(seconds: 5));
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
      if (deepLink.path == '/__/auth/action') {
        logInuser(deepLink.toString());
      }
    }
  }

  void handleDynamicLinkOpenedFromBackgroundState() {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink.link;

        if (deepLink != null) {
          //TODO: Replace with FirebaseAuth.instance.isSignInWithEmailLink(emailLink) check

          if (deepLink.path == '/__/auth/action') {
            logInuser(deepLink.toString());
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        log('Error while recieving dynamic link', error: error);
      },
    );
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
    ref.listen<LogInState>(signInProvider,
        (LogInState? oldState, LogInState newState) {
      newState.when(
        data: () {
          setState(() {
            signinmethod = null;
          });
        },
        multiAuth:
            (List<String> authProviders, AuthCredential credentials) async {
          setState(() {
            authCredential = credentials;
          });
          final SIGNINMETHOD? knownAuthProvider =
              await showDialog<SIGNINMETHOD?>(
            context: context,
            builder: (BuildContext context) {
              return MultiAuthDialog(existingProviders: authProviders);
            },
          );

          if (knownAuthProvider != null) {
            if (knownAuthProvider != SIGNINMETHOD.Email) {
              await ref
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
        error: (ChaseAppCallException e, StackTrace? stk) {
          setState(() {
            signinmethod = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
            ),
          );
        },
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          children: [
            const Spacer(),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingMediumConstant),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    if (isLoggingWithEmail && signinmethod == null)
                      Text(
                        'Continue with your Email',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline4!.fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ...socialSigninMethods.map((SIGNINMETHOD method) {
                      if (method == SIGNINMETHOD.Apple && Platform.isAndroid) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: kItemsSpacingSmall),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
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
                            duration: const Duration(milliseconds: 300),
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
                                    shouldAnimate:
                                        // signinmethod != SIGNINMETHOD.Email
                                        //     ?
                                        signinmethod == method,
                                    child: method == SIGNINMETHOD.Email
                                        ? const Icon(Icons.email)
                                        : SvgPicture.asset(
                                            method.getAssetIcon,
                                            height: kIconSizeLargeConstant,
                                          ),
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
                                    duration: const Duration(milliseconds: 300),
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
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              decoration: InputDecoration(
                                                hintText: 'Enter',
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColorLight,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            signinmethod == method
                                                ? ''
                                                : 'Continue With ${method.name}',
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
              },
            ),
            const Spacer(),
            LogInFooter(
              isLoggingWithEmail: isLoggingWithEmail,
              isEmailSignInMethod: signinmethod == SIGNINMETHOD.Email,
              onTap: () {
                setState(() {
                  focusScopeNode.unfocus();
                  _textEditingController.clear();
                  isLoggingWithEmail = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
