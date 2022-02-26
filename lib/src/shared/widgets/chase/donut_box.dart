import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
        SizedBox(
          width: kItemsSpacingSmallConstant,
        ),
        Text(
          NumberFormat('#,###').format(chase.votes ?? 0),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    ));
  }
}
