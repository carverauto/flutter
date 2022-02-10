import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
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
        tileColor: primaryColor.shade600,
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusSmallConstant / 2),
        ),
        leading: Hero(
          tag: "Chase" + chase.createdAt.toString(),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              height: double.maxFinite,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  kBorderRadiusSmallConstant / 2,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Theme.of(context).shadowColor,
                  ),
                ],
              ),
              child: chase.imageURL != null && chase.imageURL!.isNotEmpty
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: parseImageUrl(
                        chase.imageURL!,
                        ImageDimensions.SMALL,
                      ),
                      placeholder: (context, value) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, value, dynamic value2) {
                        return Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    )
                  : Image(
                      fit: BoxFit.cover,
                      image: AssetImage(defaultChaseImage),
                    ),
            ),
          ),
        ),
        title: Text(
          chase.name ?? "NA",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        subtitle: Text(
          dateAdded(chase),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(190),
          ),
        ),
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
              "chaseId": chase.id,
            },
          );
        });
  }
}
