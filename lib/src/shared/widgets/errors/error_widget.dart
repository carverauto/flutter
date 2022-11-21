import 'package:flutter/material.dart';

import '../../../const/sizings.dart';
import '../../../routes/routeNames.dart';

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
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(kBorderRadiusLargeConstant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kPaddingXSmallConstant),
                child: Text(
                  message ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.2),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteName.SUPPORT);
              },
              child: const Text(
                'Report',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
