import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../../../../const/colors.dart';
import '../../../../const/images.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../shared/widgets/buttons/medium_clap_flutter.dart';

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
      trailing: (int counter) => Text(
        NumberFormat('#,###').format(chase.votes ?? 0),
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: primaryColor.shade300,
            ),
      ),
      clapFabCallback: (int upCount) async {
        try {
          await ref.read(chaseRepoProvider).upVoteChase(upCount, chase.id);
        } catch (e, stk) {
          logger.warning(
            'Error while upvoting a Chase',
            e,
            stk,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
