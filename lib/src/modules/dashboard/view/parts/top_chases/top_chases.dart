import 'package:carousel_slider/carousel_slider.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/top_chases/top_chase_builder.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

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
      builder: (chases) {
        return chases.isEmpty
            ? Column(
                children: [
                  IconButton(
                    onPressed: () {
                      ref
                          .read(chasesPaginatedStreamProvider(logger).notifier)
                          .fetchFirstPage(true);
                    },
                    icon: Icon(Icons.replay),
                  ),
                  Chip(
                    label: Text("No Chases Found!"),
                  ),
                ],
              )
            : SizedBox(
                width: Sizescaleconfig.screenwidth,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: Sizescaleconfig.screenheight! * 0.4,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                  ),
                  items: chases
                      .asMap()
                      .map<int, Widget>(
                        (index, chase) => MapEntry(
                          index,
                          TweenAnimationBuilder<double>(
                            key: UniqueKey(),
                            duration: Duration(milliseconds: 300),
                            tween: Tween<double>(begin: 0.8, end: 1),
                            builder: (context, value, child) {
                              return ScaleTransition(
                                scale: AlwaysStoppedAnimation(value),
                                child: child,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingMediumConstant,
                              ),
                              child: Stack(
                                children: [
                                  TopChaseBuilder(
                                    chase: chase,
                                  ),
                                  Positioned(
                                    right: kPaddingMediumConstant,
                                    top: kPaddingMediumConstant,
                                    child: Text(
                                      "${index + 1} / ${chases.length}",
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
