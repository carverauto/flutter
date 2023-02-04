import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../const/colors.dart';
import '../../../const/images.dart';
import '../../../const/sizings.dart';
import '../../../models/chase/chase.dart';
import '../../../routes/routeNames.dart';
import '../../util/helpers/date_added.dart';
import '../../util/helpers/image_url_parser.dart';
import 'donut_box.dart';

class ChaseTile extends StatelessWidget {
  const ChaseTile({
    super.key,
    required this.chase,
  });

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: primaryColor.shade600,
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusStandard),
        ),
        leading: Hero(
          tag: 'Chase${chase.createdAt}',
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              height: double.maxFinite,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  kBorderRadiusStandard,
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
                      placeholder: (BuildContext context, String value) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (BuildContext context, String value, dynamic value2) {
                        return Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    )
                  : const Image(
                      fit: BoxFit.cover,
                      image: AssetImage(defaultAssetChaseImage),
                    ),
            ),
          ),
        ),
        title: Text(
          chase.name ?? 'NA',
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
        trailing: DonutBox(
          chase: chase,
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteName.CHASE_VIEW,
            arguments: {
              'chaseId': chase.id,
            },
          );
        },);
  }
}
