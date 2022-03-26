import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../const/links.dart';
import '../../../../shared/util/helpers/launchLink.dart';

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
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: isLoggingWithEmail
          ? isEmailSignInMethod
              ? const SizedBox.shrink()
              : TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: onTap,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                )
          : RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'By signing in you agree to the',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  TextSpan(
                    text: ' terms of service',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(tosPolicy);
                      },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  TextSpan(
                    text: 'privacy policy',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(privacyPolicy);
                      },
                  ),
                ],
              ),
            ),
    );
  }
}
