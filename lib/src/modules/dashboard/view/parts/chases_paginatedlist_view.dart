import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/paginatedlist_bottom.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/top_chases/top_chase_builder.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ChasesPaginatedListView extends ConsumerWidget {
  ChasesPaginatedListView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
    required this.scrollController,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<Chase>,
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
        builder: (chases, controller, [Widget? bottomWidget]) {
          return chases.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(chasesPaginatedStreamProvider(logger)
                                  .notifier)
                              .fetchFirstPage(true);
                        },
                        icon: Icon(Icons.replay),
                      ),
                      Chip(
                        label: Text("No Chases Found!"),
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
                          crossAxisCount: axis == Axis.horizontal ? 1 : 2,
                          childAspectRatio: 1.2,
                          mainAxisSpacing: kItemsSpacingSmallConstant,
                          padding: EdgeInsets.symmetric(
                              horizontal: kItemsSpacingMediumConstant),
                          scrollDirection: axis,
                          crossAxisSpacing: kItemsSpacingSmallConstant,
                          children: chases.map((chase) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: kPaddingMediumConstant,
                              ),
                              child: TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 300),
                                tween: Tween<double>(begin: 0.8, end: 1),
                                builder: (context, value, child) {
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
                                padding: const EdgeInsets.all(8.0),
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
                      childAspectRatio: Sizescaleconfig.getDeviceType ==
                              DeviceType.SMALL_MOBILE
                          ? 1.2
                          : 0.8,
                      children: chases
                          .map<Widget>((chase) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: kPaddingMediumConstant,
                                ),
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 300),
                                  tween: Tween<double>(begin: 0.8, end: 1),
                                  builder: (context, value, child) {
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
                              ))
                          .toList(),
                    );
        });
  }
}
