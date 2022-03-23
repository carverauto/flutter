import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../const/sizings.dart';
import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/chase/chase.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/util/helpers/image_url_parser.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';
import '../../../../shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import '../../../../shared/widgets/loaders/shimmer_tile.dart';
import '../../../dashboard/view/parts/paginatedlist_bottom.dart';
import '../pages/top_chases/top_chase_builder.dart';
import '../providers/providers.dart';

class ChasesPaginatedListView extends ConsumerWidget {
  const ChasesPaginatedListView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
    required this.scrollController,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaginationProvider;
  final Logger logger;
  final ScrollController scrollController;

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverProviderPaginatedStateNotifierBuilder<Chase>(
      watchThisStateNotifierProvider: chasesPaginationProvider,
      logger: logger,
      scrollController: scrollController,
      axis: axis,
      loadingBuilder: () {
        return const Padding(
          padding: EdgeInsets.all(kPaddingMediumConstant),
          child: ShimmerTile(height: 300),
        );
      },
      builder: (
        List<Chase> chases,
        ScrollController controller, [
        Widget? bottomWidget,
      ]) {
        return chases.isEmpty
            ? SliverToBoxAdapter(
                child: Column(
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
                ),
              )
            : axis == Axis.horizontal
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: GridView.count(
                        controller: scrollController,
                        crossAxisCount: 1,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: kItemsSpacingSmallConstant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: kItemsSpacingMediumConstant,
                        ),
                        scrollDirection: axis,
                        crossAxisSpacing: kItemsSpacingSmallConstant,
                        children: chases.sublist(3).map((Chase chase) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: kPaddingMediumConstant,
                            ),
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 300),
                              tween: Tween<double>(begin: 0.8, end: 1),
                              builder: (BuildContext context, double value,
                                  Widget? child) {
                                return ScaleTransition(
                                  scale: AlwaysStoppedAnimation(value),
                                  child: child,
                                );
                              },
                              child: TopChaseBuilder(
                                chase: chase,
                                imageDimensions: ImageDimensions.SMALL,
                              ),
                            ),
                          );
                        }).toList()
                          ..add(
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: PaginatedListBottom(
                                chasesPaginationProvider:
                                    chasesPaginationProvider,
                              ),
                            ),
                          ),
                      ),
                    ),
                  )
                : SliverGrid.count(
                    crossAxisCount: Sizescaleconfig.getDeviceType.count,
                    childAspectRatio:
                        Sizescaleconfig.getDeviceType == DeviceType.SMALL_MOBILE
                            ? 1.2
                            : 0.8,
                    children: chases
                        .map<Widget>(
                          (Chase chase) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: kPaddingMediumConstant,
                            ),
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 300),
                              tween: Tween<double>(begin: 0.8, end: 1),
                              builder: (BuildContext context, double value,
                                  Widget? child) {
                                return ScaleTransition(
                                  scale: AlwaysStoppedAnimation(value),
                                  child: child,
                                );
                              },
                              child: TopChaseBuilder(
                                chase: chase,
                                imageDimensions: ImageDimensions.SMALL,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
      },
    );
  }
}
