import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../const/sizings.dart';
import '../../../../../models/chase/chase.dart';
import '../../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../../../shared/widgets/carousal_slider.dart';
import '../../../../../shared/widgets/loaders/shimmer_tile.dart';
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
    return SliverProviderStateBuilder<List<Chase>>(
      watchThisProvider: topChasesStreamProvider,
      logger: logger,
      loadingBuilder: () {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kPaddingLargeConstant),
          child: ShimmerTile(
            height: MediaQuery.of(context).size.width * 9 / 16,
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
              : CarousalSlider(
                  carouselOptions: CarouselOptions(
                    height: MediaQuery.of(context).size.width * 9 / 16,
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
