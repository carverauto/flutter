import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/images.dart';
import '../../const/sizings.dart';
import '../../models/birds_of_fire/birds_of_fire.dart';
import '../../shared/widgets/builders/image_builder.dart';
import 'providers.dart';

class BofView extends ConsumerWidget {
  const BofView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<BirdsOfFire>> bofStream =
        ref.watch(bofStreamProvider);

    return bofStream.when(
      data: (List<BirdsOfFire> bofObjects) {
        // group bof objects based on the dbscan property
        final List<BirdsOfFire> clusteredBofObjects = bofObjects
            .where((BirdsOfFire bof) => bof.properties.cluster != null)
            .toList();
        if (clusteredBofObjects.isEmpty) {
          return const SizedBox.shrink();
        }
        final Map<int, List<BirdsOfFire>> bofGroups = groupBy(
          clusteredBofObjects,
          (BirdsOfFire bof) => bof.properties.cluster!,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPaddingMediumConstant),
              child: Text(
                '🚨 Cluster Alert',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: kPaddingSmallConstant,
            ),
            SizedBox(
              height: kToolbarHeight + 10,
              child: ListView.builder(
                itemCount: bofGroups.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int clusterValue = bofGroups.keys.elementAt(index);
                  final List<BirdsOfFire> bofgroup = bofGroups[clusterValue]!;
                  final String group = bofgroup.first.properties.group;

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: kPaddingMediumConstant,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   group,
                        //   style:
                        //       Theme.of(context).textTheme.bodyMedium!.copyWith(
                        //             color: Colors.white,
                        //           ),
                        // ),
                        // const SizedBox(
                        //   height: kPaddingXSmallConstant,
                        // ),
                        Row(
                          children: bofgroup.map<Widget>((BirdsOfFire e) {
                            final String imageUrl = e
                                    .properties.imageUrl.isEmpty
                                ? defaultAssetChaseImage
                                : 'https://chaseapp.tv/${e.properties.imageUrl}';

                            return Align(
                              widthFactor: 0.5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: AdaptiveImageProvider(
                                    imageUrl,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace? stack) => Text(error.toString()),
    );
  }
}
