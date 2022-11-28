import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../const/sizings.dart';
import '../../../../../device_info.dart';
import '../../../../../models/chase/chase.dart';
import '../../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../../../shared/widgets/carousal_slider.dart';
import '../../../../../shared/widgets/loaders/shimmer_tile.dart';
import '../../../../firehose/view/pages/firehose.dart';
import '../../../../firehose/view/providers/providers.dart';
import '../../providers/providers.dart';
import 'top_chase_builder.dart';

class TopChasesListView extends ConsumerWidget {
  const TopChasesListView({
    Key? key,
    required this.logger,
  }) : super(key: key);

  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final double carousalHeight = width * 9 / 16 > width * 0.4 * 9 / 16
        ? width * 0.4 * 9 / 16
        : width * 9 / 16;

    return SliverProviderStateBuilder<List<Chase>>(
      watchThisProvider: topChasesStreamProvider,
      logger: logger,
      loadingBuilder: () {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kPaddingLargeConstant),
          child: ShimmerTile(
            height: carousalHeight,
          ),
        );
      },
      builder: (List<Chase> chases) {
        return SliverToBoxAdapter(
          child: chases.isEmpty
              ? Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(
                              chasesPaginatedStreamProvider(logger).notifier,
                            )
                            .fetchFirstPage(true);
                      },
                      icon: const Icon(Icons.replay),
                    ),
                    const Chip(
                      label: Text('No Chases Found!'),
                    ),
                  ],
                )
              : DeviceScreen.isLandscapeTablet(context)
                  ? SizedBox(
                      height: carousalHeight + 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(kListPaddingConstant),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadiusStandard,
                                  ),
                                ),
                                child: CarousalSlider(
                                  carouselOptions: CarouselOptions(
                                    height: carousalHeight,
                                    viewportFraction: 0.8,
                                    padEnds: false,
                                  ),
                                  builder: (
                                    BuildContext context,
                                    int index,
                                    Widget child,
                                    double primaryAnimation,
                                    double secondaryAnimation,
                                  ) {
                                    return Opacity(
                                      opacity: secondaryAnimation,
                                      child: child,
                                    );
                                  },
                                  childrens: chases
                                      .asMap()
                                      .map<int, Widget>(
                                        (int index, Chase chase) => MapEntry(
                                          index,
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Stack(
                                              children: [
                                                TopChaseBuilder(
                                                  chase: chase,
                                                ),
                                                Positioned(
                                                  right: kPaddingMediumConstant,
                                                  top: kPaddingMediumConstant,
                                                  child: Text(
                                                    '${index + 1} / ${chases.length}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .values
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: kPaddingMediumConstant,
                          ),
                          SizedBox(
                            width: width * 0.4,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(
                                  kBorderRadiusStandard,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(kListPaddingConstant)
                                        .copyWith(
                                  bottom: 0,
                                ),
                                child: FireHoseListView(
                                  logger: logger,
                                  itemsPaginationProvider:
                                      firehosePaginatedStateNotifierProvier(
                                    logger,
                                  ),
                                  showLimited: true,
                                  scrollController: ScrollController(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : CarousalSlider(
                      carouselOptions: CarouselOptions(
                        height: width * 9 / 16,
                        viewportFraction: 0.8,
                      ),
                      builder: (
                        BuildContext context,
                        int index,
                        Widget child,
                        double primaryAnimation,
                        double secondaryAnimation,
                      ) {
                        return Transform.scale(
                          scale: secondaryAnimation,
                          child: child,
                        );
                      },
                      childrens: chases
                          .asMap()
                          .map<int, Widget>(
                            (int index, Chase chase) => MapEntry(
                              index,
                              Stack(
                                children: [
                                  TopChaseBuilder(
                                    chase: chase,
                                  ),
                                  Positioned(
                                    right: kPaddingMediumConstant,
                                    top: kPaddingMediumConstant,
                                    child: Text(
                                      '${index + 1} / ${chases.length}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .values
                          .toList(),
                    ),
        );
      },
    );
  }
}
