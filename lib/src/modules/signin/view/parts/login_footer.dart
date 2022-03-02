import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LogInFooter extends StatelessWidget {
  const LogInFooter({
    Key? key,
    required this.onTap,
    required this.isLoggingWithEmail,
    required this.isEmailSignInMethod,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isLoggingWithEmail;
  final bool isEmailSignInMethod;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: isLoggingWithEmail
          ? isEmailSignInMethod
              ? SizedBox.shrink()
              : TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    side: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: onTap,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                )
          : RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: "By signing in you agree to the",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
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
                    color: Theme.of(context).primaryColorLight,
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
              ])),
    );
  }
}
