import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../const/images.dart';
import '../../../const/sizings.dart';
import '../../../models/chase/chase.dart';
import '../buttons/glass_button.dart';

class DonutBox extends StatelessWidget {
  const DonutBox({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            donutSVG,
            height: kIconSizeSmallConstant,
          ),
          const SizedBox(
            width: kItemsSpacingSmallConstant,
          ),
          Text(
            NumberFormat('#,###').format(chase.votes ?? 0),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
