import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import '../../../../const/colors.dart';
import '../../../../const/images.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../shared/widgets/buttons/medium_clap_flutter.dart';
import '../providers/providers.dart';

class DonutClapButton extends ConsumerWidget {
  const DonutClapButton({
    super.key,
    required this.chaseId,
    required this.logger,
  });

  final String chaseId;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? votes = ref.watch(
      streamChaseProvider(chaseId).select((AsyncValue<Chase> value) {
        return value.value?.votes;
      }),
    );

    return ClapFAB.image(
      trailing: (int counter) => Text(
        NumberFormat('#,###').format(votes ?? 0),
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: primaryColor.shade300,
            ),
      ),
      clapFabCallback: (int upCount) async {
        try {
          await ref.read(chaseRepoProvider).upVoteChase(upCount, chaseId);
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
