import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/widgets/buttons/medium_clap_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class DonutClapButton extends ConsumerWidget {
  const DonutClapButton({
    Key? key,
    required this.chase,
    required this.logger,
  }) : super(key: key);

  final Chase chase;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClapFAB.image(
      trailing: (counter) => Text(
        chase.votes.toString(),
        style: Theme.of(context).textTheme.headline5!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      clapFabCallback: (int upCount) async {
        try {
          //TODO: Improve this handling
          ref.read(chaseRepoProvider).upVoteChase(upCount, chase.id);
        } catch (e, stk) {
          logger.warning(
            "Error while upvoting a Chase",
            e,
            stk,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Something went wrong. Please try again later.',
              ),
            ),
          );
        }
      },
      defaultImage: donutImage,
      filledImage: donutImage,
      countCircleColor: Colors.pink,
      hasShadow: true,
      sparkleColor: Colors.red,
      shadowColor: Colors.pink,
      defaultImageColor: Colors.pink,
      filledImageColor: Colors.pink,
    );
  }
}
