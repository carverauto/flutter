import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/sizings.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../shared/util/helpers/dynamiclink_generator.dart';
import '../../../../shared/widgets/errors/error_widget.dart';
import '../../../../shared/widgets/sentiment_analysis_slider.dart';
import '../../../../shared/widgets/stripes_shader_builder.dart';
import '../providers/providers.dart';
import 'chase_details_page_internal.dart';
import 'chase_hero.dart';
import 'chase_wheel.dart';
import 'donut_clap_button.dart';

class ChaseDetailsReactiveInformation extends StatelessWidget {
  const ChaseDetailsReactiveInformation({
    Key? key,
    required this.chaseId,
    required this.logger,
  }) : super(key: key);

  final String chaseId;
  final Logger logger;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      child: DonutClapButton(
        chaseId: chaseId,
        logger: logger,
      ),
      builder: (BuildContext context, WidgetRef ref, Widget? donut) {
        //TODO: find a good way to only watch chasedetails relevant here and not rebuild on votes change
        final AsyncValue<Chase> chaseDetails =
            ref.watch(streamChaseProvider(chaseId));

        return chaseDetails.when(
          data: (Chase chase) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sentiment Analysis :',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(
                  height: kItemsSpacingExtraSmallConstant,
                ),
                SentimentSlider(chase: chase),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      child: ButtonBar(
                        children: [
                          IconButton(
                            onPressed: () async {
                              try {
                                final String shareLink =
                                    await createChaseDynamicLink(
                                  chase,
                                  ref.read(
                                    firebaseDynamicLinksProvider,
                                  ),
                                );
                                await Share.share(shareLink);
                              } catch (e, stk) {
                                logger.warning(
                                  'Chase Sharing Failed!',
                                  e,
                                  stk,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.share,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.bookmark_border,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: kIconSizeLargeConstant + 20,
                      width: kIconSizeLargeConstant + 20,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusSmallConstant),
                        child: ColoredBox(
                          color: Colors.grey[600]!,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: kIconSizeLargeConstant + 20,
                                      width: kPaddingXSmallConstant,
                                      child: RepaintBoundary(
                                        child: ColoredBox(
                                          color: Colors.grey[600]!,
                                          child: AnimatedBuilder(
                                            animation:
                                                ChaseAppYoutubeController.of(
                                              context,
                                            ).youtubePlayerController,
                                            child: const SizedBox.expand(
                                              child: ColoredBox(
                                                color: Colors.white,
                                              ),
                                            ),
                                            builder: (
                                              BuildContext context,
                                              Widget? child,
                                            ) {
                                              final YoutubePlayerController
                                                  controller =
                                                  ChaseAppYoutubeController.of(
                                                context,
                                              ).youtubePlayerController;

                                              return StripesShaderBuilder(
                                                isActive:
                                                    controller.value.isPlaying,
                                                direction: 0.25,
                                                child: child!,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: kIconSizeLargeConstant + 20,
                                      width: kPaddingXSmallConstant,
                                      child: ColoredBox(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ChaseAppWheel(
                                wheels: chase.wheels,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: donut!,
                    ),
                  ],
                ),
              ],
            );
          },
          error: (Object error, StackTrace? stackTrace) {
            return ChaseAppErrorWidget(
              onRefresh: () {
                ref.refresh(streamChaseProvider(chaseId));
              },
            );
          },
          loading: () {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class ChaseHeroSectionBuilder extends ConsumerWidget {
  const ChaseHeroSectionBuilder({
    Key? key,
    required this.chase,
    required this.imageUrl,
    required this.youtubeVideo,
  }) : super(key: key);

  final Chase chase;
  final String? imageUrl;
  final Widget youtubeVideo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTyping = MediaQuery.of(context).viewInsets.bottom > 0;
    final num bottomPadding =
        isTyping ? MediaQuery.of(context).size.height * 0.15 : 0;
    final num extraSizing = isTyping ? kToolbarHeight : 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.width * (9 / 16) -
          bottomPadding +
          extraSizing,
      width: double.maxFinite,
      child: ChaseHeroSection(
        chaseId: chase.id,
        imageURL: imageUrl,
        youtubeVideo: youtubeVideo,
      ),
    );

    // return TweenAnimationBuilder<double>(
    //   tween: Tween<double>(
    //     begin: MediaQuery.of(context).size.width * (9 / 16),
    //     end: MediaQuery.of(context).size.width * (9 / 16) -
    //         bottomPadding +
    //         extraSizing,
    //   ),
    //   duration: const Duration(milliseconds: 200),
    //   child: ChaseHeroSection(
    //     chase: chase,
    //     imageURL: imageUrl,
    //     youtubeVideo: youtubeVideo,
    //   ),
    //   builder: (BuildContext context, double animation, Widget? child) {
    //     log(animation.toString());

    //     return SizedBox(
    //       height: animation,
    //       width: double.maxFinite,
    //       child: child,
    //     );
    //   },
    // );
  }
}
