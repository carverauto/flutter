import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChaseTile extends StatelessWidget {
  const ChaseTile({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: kBorderSideWidthSmallConstant,
          ),
          borderRadius: BorderRadius.circular(kBorderRadiusSmallConstant),
        ),
        title: Text(
          chase.name ?? "NA",
        ),
        subtitle: Text(dateAdded(chase)),
        trailing: Chip(
          elevation: kElevation,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          avatar: SvgPicture.asset(donutSVG),
          label: Text(
            chase.votes.toString(),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteName.CHASE_VIEW,
            arguments: {
              "chase": chase,
            },
          );
        });
  }
}
