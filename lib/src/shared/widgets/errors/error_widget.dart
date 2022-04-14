import 'package:flutter/material.dart';

import '../../../const/sizings.dart';

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
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(
                Icons.replay,
                color: Colors.white,
              ),
            ),
            //Chip doesn't show label properly with multiline text
            Chip(
              label: Text(
                message ?? 'Something went wrong.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
