import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/images.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/watch_youtube_video_button.dart';
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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomPadding > 0;
    final isYoutubeUrlPresent = widget.chase.networks?.any((network) {
          final url = network.url;

          if (url != null) {
            return url.contains("youtube.com");
          }
          return false;
        }) ??
        false;
    return playVideo
        ? widget.youtubeVideo

        //  Stack(
        //     children: [
        //       widget.youtubeVideo,
        //       Positioned(
        //         top: kItemsSpacingMediumConstant,
        //         right: kItemsSpacingMediumConstant,
        //         child: GlassButton(
        //           shape: CircleBorder(),
        //           onTap: () {
        //             setState(() {
        //               ref
        //                   .read(playVideoProvider.state)
        //                   .update((state) => false);
        //             });
        //           },
        //           child: Icon(
        //             Icons.close,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ),
        //     ],
        //   )
        : GestureDetector(
            onTap: () {
              setState(() {
                ref.read(playVideoProvider.state).update((state) => true);
              });
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: widget.chase.imageURL != null &&
                          widget.chase.imageURL!.isNotEmpty
                      ? CachedNetworkImage(
                          fit: isKeyboardVisible ? BoxFit.cover : BoxFit.fill,
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
                if (isYoutubeUrlPresent)
                  Align(
                    alignment: Alignment.center,
                    child:
                        WatchYoutubeVideo(isLive: widget.chase.live ?? false),
                  ),
              ],
            ),
          );
  }
}

class ClosePlayingVideo extends ConsumerWidget {
  const ClosePlayingVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassButton(
      shape: CircleBorder(),
      onTap: () {
        ref.read(playVideoProvider.state).update((state) => false);
      },
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }
}
