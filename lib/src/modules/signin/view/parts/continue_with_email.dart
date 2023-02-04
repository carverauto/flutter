import 'package:flutter/material.dart';

class ContinueWithEmailWidget extends StatelessWidget {
  const ContinueWithEmailWidget({
    super.key,
    required this.isLoggingWithEmail,
  });

  final bool isLoggingWithEmail;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return child;
      },
      child: isLoggingWithEmail
          ? Text(
              'Continue with your Email',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
