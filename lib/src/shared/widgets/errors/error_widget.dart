import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

class ChaseAppErrorWidget extends StatelessWidget {
  const ChaseAppErrorWidget({
    Key? key,
    this.message,
    required this.onRefresh,
  }) : super(key: key);

  final String? message;

  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onRefresh,
              icon: Icon(Icons.replay),
            ),
            //Chip doesn't show label properly with multiline text
            Chip(
              label: Text(message ?? "Something went wrong."),
            ),
          ],
        ),
      ),
    );
  }
}
