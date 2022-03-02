import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/aspect_ratio.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChaseHeroSection extends ConsumerStatefulWidget {
  ChaseHeroSection({
    Key? key,
    required this.chase,
    required this.imageURL,
    required this.youtubeVideo,
  }) : super(key: key);

  final Chase chase;
  final String? imageURL;
  final Widget youtubeVideo;

  @override
  ConsumerState<ChaseHeroSection> createState() => _ChaseHeroSectionState();
}

class _ChaseHeroSectionState extends ConsumerState<ChaseHeroSection> {
  @override
  Widget build(BuildContext context) {
    final playVideo = ref.watch(playVideoProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    log(isLandscape.toString());
    return AspectRatio(
      aspectRatio: aspectRatioStandard,
      child: playVideo
          ? Stack(
              children: [
                widget.youtubeVideo,
                Positioned(
                  top: kItemsSpacingMediumConstant,
                  right: kItemsSpacingMediumConstant,
                  child: GlassButton(
                    shape: CircleBorder(),
                    onTap: () {
                      setState(() {
                        ref
                            .read(playVideoProvider.state)
                            .update((state) => false);
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: widget.chase.imageURL != null &&
                          widget.chase.imageURL!.isNotEmpty
                      ? CachedNetworkImage(
                          fit: BoxFit.fill,
                          maxWidthDiskCache: 750,
                          maxHeightDiskCache: 421,
                          memCacheHeight: 421,
                          memCacheWidth: 750,
                          imageUrl: parseImageUrl(
                            widget.imageURL!,
                            ImageDimensions.LARGE,
                          ),
                          placeholder: (context, value) =>
                              CircularAdaptiveProgressIndicatorWithBg(),
                          errorWidget: (context, value, dynamic value2) {
                            return ImageLoadErrorWidget();
                          },
                        )
                      : Image(
                          fit: BoxFit.cover,
                          image: AssetImage(defaultAssetChaseImage),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: kItemsSpacingMediumConstant,
                  child: Tooltip(
                    message: 'Watch Youtube Video',
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ref
                              .read(playVideoProvider.state)
                              .update((state) => true);
                        });
                      },
                      child: Chip(
                        label: Icon(
                          Icons.video_call_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
