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

        final Map<int, List<BirdsOfFire>> bofGroups = groupBy(
          clusteredBofObjects,
          (BirdsOfFire bof) => bof.properties.cluster!,
        );
        WidgetsBinding.instance.addPostFrameCallback((Duration t) {
          ref
              .read(isBOFActiveProvider.state)
              .update((bool state) => clusteredBofObjects.isNotEmpty);
        });

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(animation),
                child: child,
              ),
            );
          },
          child: clusteredBofObjects.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: kPaddingMediumConstant),
                      child: Text(
                        '🚨 Cluster Alert',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
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
                      child: ClusterIconsList(bofGroups: bofGroups),
                    ),
                  ],
                ),
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

class ClusterIconsList extends ConsumerStatefulWidget {
  const ClusterIconsList({
    super.key,
    required this.bofGroups,
  });

  final Map<int, List<BirdsOfFire>> bofGroups;

  @override
  ConsumerState<ClusterIconsList> createState() => _ClusterIconsListState();
}

class _ClusterIconsListState extends ConsumerState<ClusterIconsList> {
  late List<int> activeClusters;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeClusters = [];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.bofGroups.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final int clusterValue = widget.bofGroups.keys.elementAt(index);
        final List<BirdsOfFire> bofgroup = widget.bofGroups[clusterValue]!;

        return Padding(
          padding: const EdgeInsets.only(
            left: kPaddingMediumConstant + kPaddingSmallConstant,
          ),
          child: Row(
            children: bofgroup.map<Widget>((BirdsOfFire e) {
              final String imageUrl = e.properties.imageUrl.isEmpty
                  ? defaultAssetChaseImage
                  : 'https://chaseapp.tv/${e.properties.imageUrl}';
              final int? cluster = e.properties.cluster;
              final bool isActive = activeClusters.contains(cluster);

              return GestureDetector(
                onTap: () {
                  if (cluster != null) {
                    if (!isActive) {
                      setState(() {
                        activeClusters.add(cluster);
                      });
                    }
                  }
                  ref
                      .read(
                        activeClusterCoordinateProvider.state,
                      )
                      .update(
                        (BirdsOfFire? state) => e,
                      );
                },
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  widthFactor: isActive ? 1.15 : 0.6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          spreadRadius: 1,
                          color: Theme.of(context).colorScheme.primary,
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
    );
  }
}

// // dummy data with 3 different groups with cluster value 0,1,2 and 3 items each group
// List<BirdsOfFire> bofgroupDummyData = [
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 0,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 0,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 0,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 1,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 1,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 1,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 2,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
//   const BirdsOfFire(
//     properties: BofProperties(
//       title: 'title',
//       imageUrl: '/networks/koco.jpg',
//       cluster: 2,
//       group: '0',
//       dbscan: 'hello',
//       type: 'plane',
//     ),
//     geometry: BOFGeometry(
//       coordinates: [0, 0],
//       type: 'plane',
//     ),
//   ),
// ];
