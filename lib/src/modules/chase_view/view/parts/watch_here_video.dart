import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/widgets/views/showurls.dart';
import 'package:flutter/material.dart';

class WatchHereLinksWrapper extends StatelessWidget {
  const WatchHereLinksWrapper({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMediumConstant,
        vertical: kPaddingSmallConstant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Watch here :",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  //  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          SizedBox(
            height: kItemsSpacingSmallConstant,
          ),
          chase.networks != null
              ? URLView(chase.networks as List<Map>)
              : const Text('Please wait..'),
        ],
      ),
    );
  }
}
