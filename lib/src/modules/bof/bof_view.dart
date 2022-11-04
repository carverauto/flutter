import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../const/images.dart';
import '../../const/sizings.dart';
import '../../models/birds_of_fire/birds_of_fire.dart';
import '../../shared/widgets/builders/image_builder.dart';
import 'providers.dart';

final StateProvider<bool> isBOFActiveProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final StateProvider<BirdsOfFire?> activeClusterCoordinateProvider =
    StateProvider<BirdsOfFire?>((StateProviderRef<BirdsOfFire?> ref) {
  return null;
});

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
          WidgetsBinding.instance.addPostFrameCallback((Duration t) {
            ref.read(isBOFActiveProvider.state).update((bool state) => false);
          });
          return const SizedBox.shrink();
        }
        final Map<int, List<BirdsOfFire>> bofGroups = groupBy(
          clusteredBofObjects,
          (BirdsOfFire bof) => bof.properties.cluster!,
        );
        WidgetsBinding.instance.addPostFrameCallback((Duration t) {
          ref.read(isBOFActiveProvider.state).update((bool state) => true);
        });

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

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: kPaddingMediumConstant,
                    ),
                    child: Row(
                      children: bofgroup.map<Widget>((BirdsOfFire e) {
                        final String imageUrl = e.properties.imageUrl.isEmpty
                            ? defaultAssetChaseImage
                            : 'https://chaseapp.tv/${e.properties.imageUrl}';

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(activeClusterCoordinateProvider.state)
                                .update(
                                  (BirdsOfFire? state) => e,
                                );
                          },
                          child: Align(
                            widthFactor: 0.6,
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
                                radius: 25,
                                backgroundImage: AdaptiveImageProvider(
                                  imageUrl,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: SizedBox.shrink,
      error: (Object error, StackTrace? stack) {
        Logger('BOF VIEW').warning(error, stack);

        return const SizedBox.shrink();
      },
    );
  }
}
