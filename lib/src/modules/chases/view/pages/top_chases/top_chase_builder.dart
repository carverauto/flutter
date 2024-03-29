import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../const/colors.dart';
import '../../../../../const/images.dart';
import '../../../../../const/sizings.dart';
import '../../../../../models/chase/chase.dart';
import '../../../../../routes/routeNames.dart';
import '../../../../../shared/util/helpers/date_added.dart';
import '../../../../../shared/util/helpers/image_url_parser.dart';
import '../../../../../shared/widgets/buttons/glass_button.dart';
import '../../../../../shared/widgets/chase/donut_box.dart';
import '../../../../../shared/widgets/sentiment_analysis_slider.dart';
import '../../../../signin/view/parts/gradient_animation_container.dart';

class TopChaseBuilder extends StatelessWidget {
  const TopChaseBuilder({
    super.key,
    required this.chase,
    this.imageDimensions = ImageDimensions.MEDIUM,
  });

  final Chase chase;

  final ImageDimensions imageDimensions;

  @override
  Widget build(BuildContext context) {
    final bool isImagePresent =
        chase.imageURL != null && chase.imageURL!.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              kBorderRadiusStandard,
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                primaryColor.shade900,
                Colors.transparent,
              ],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              kBorderRadiusStandard,
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: isImagePresent
                  ? CachedNetworkImageProvider(
                      parseImageUrl(chase.imageURL!, imageDimensions),
                    )
                  : const ResizeImage(
                      AssetImage(
                        defaultAssetChaseImage,
                      ),
                      height: 544,
                      width: 484,
                    ) as ImageProvider,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await Navigator.pushNamed(
                context,
                RouteName.CHASE_VIEW,
                arguments: {
                  'chaseId': chase.id,
                  'chase': chase,
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(
                kPaddingSmallConstant,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chase.live ?? false)
                    const RepaintBoundary(
                      child: GradientAnimationChildBuilder(
                        shouldAnimate: true,
                        padding: EdgeInsets.zero,
                        child: GlassBg(
                          child: Text(
                            'Live!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    GlassBg(
                      child: Text(
                        dateAdded(chase),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chase.name ?? 'NA',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.subtitle1!.fontSize,
                        ),
                      ),
                      const SizedBox(
                        height: kItemsSpacingExtraSmallConstant,
                      ),
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: kItemsSpacingMediumConstant,
                              bottom: kItemsSpacingSmallConstant,
                            ),
                            child: SentimentSlider(
                              chase: chase,
                            ),
                          ),
                          DonutBox(
                            chase: chase,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
