import 'package:flutter/material.dart';

class ContinueWithEmailWidget extends StatelessWidget {
  const ContinueWithEmailWidget({
    Key? key,
    required this.isLoggingWithEmail,
  }) : super(key: key);

  final bool isLoggingWithEmail;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 0),
      transitionBuilder: (child, animation) {
        return child;
      },
      child: isLoggingWithEmail
          ? Text(
              "Continue with your Email",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
