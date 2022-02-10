import 'package:chaseapp/src/const/aspect_ratio.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/chase/donut_box.dart';
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
                            .read(
                                chasesPaginatedStreamProvider(logger).notifier)
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
                  child: AspectRatio(
                    aspectRatio: aspectRatioStandard,
                    child: ListView.builder(
                        itemCount: chases.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final chase = chases[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kPaddingSmallConstant,
                            ),
                            child: SizedBox(
                              width: Sizescaleconfig.screenwidth! * 0.9,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Card(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          chase.imageURL ?? defaultPhotoURL,
                                        ),
                                      ),
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Color(0xFF4D4D4D),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          kPaddingSmallConstant,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Chip(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  4,
                                                ),
                                              ),
                                              label: Text(dateAdded(chase)),
                                            ),
                                            Spacer(),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(chase.name ?? "NA"),
                                                Row(
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons
                                                            .sim_card_alert),
                                                        Slider(
                                                          value: 0.5,
                                                          onChanged: (value) {},
                                                        ),
                                                        Icon(Icons
                                                            .sim_card_alert),
                                                      ],
                                                    ),
                                                    DonutBox(chase: chase),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
        });
  }
}
