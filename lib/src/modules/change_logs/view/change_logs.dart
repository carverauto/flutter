import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../const/app_bundle_info.dart';
import '../../../const/colors.dart';
import '../../../const/other.dart';
import '../../../const/sizings.dart';
import '../../../models/changelog/changelog.dart';
import '../../../shared/util/firebase_collections.dart';
import '../../../shared/widgets/errors/error_widget.dart';
import '../../../shared/widgets/loaders/loading.dart';

class ChangeLogs extends ConsumerWidget {
  ChangeLogs({super.key});

  final Logger logger = Logger('ChangeLogsView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Changelog>> changelogState =
        ref.watch(changelogsFetchFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Changelogs'),
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              launchURL(context, AppBundleInfo.storeUrl);
            },
            child: const Text('Check for update'),
          ),
        ],
      ),
      body: changelogState.when(
        data: (List<Changelog> changelogs) {
          return ListView.builder(
            itemCount: changelogs.length,
            itemBuilder: (BuildContext context, int index) {
              final Changelog changelog = changelogs[index];
              // is last item
              final bool isLastItem = index == changelogs.length - 1;

              return Padding(
                padding: const EdgeInsets.only(
                  top: kPaddingSmallConstant,
                ),
                child: Column(
                  children: [
                    Text(
                      'v ${changelog.version}-${kDateFormat.format(changelog.updatedOn)}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      changelog.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: kPaddingXSmallConstant,
                    ),
                    if (changelog.imageUrl != null)
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                          minWidth: 200,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              kBorderRadiusStandard,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: primaryShadowColor,
                                blurRadius: blurValue,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              kBorderRadiusStandard,
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.network(
                                  changelog.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: kPaddingSmallConstant,
                    ),
                    Text(
                      changelog.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: kPaddingSmallConstant,
                    ),
                    if (!isLastItem)
                      CustomPaint(
                        painter: ChangelogslinesPainter(),
                        size: const Size(
                          100,
                          75,
                        ),
                      )
                    else
                      const SizedBox(
                        height: kPaddingMediumConstant,
                      ),
                  ],
                ),
              );
            },
          );
        },
        error: (Object e, StackTrace? stk) {
          logger.warning('Error while checking changelogs', e, stk);

          return Center(
            child: ChaseAppErrorWidget(
              onRefresh: () {
                ref.refresh(changelogsFetchFutureProvider);
              },
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularAdaptiveProgressIndicatorWithBg(),
          );
        },
      ),
    );
  }
}

final AutoDisposeFutureProvider<List<Changelog>> changelogsFetchFutureProvider =
    FutureProvider.autoDispose<List<Changelog>>(
  (AutoDisposeFutureProviderRef<List<Changelog>> ref) async {
    final DocumentSnapshot<Object?> changelog =
        await changelogsCollection.doc('changelog').get();
    final Map<String, dynamic> data = changelog.data() as Map<String, dynamic>;

    final List<Map<String, dynamic>> changelogsmapslist =
        List.castFrom<dynamic, Map<String, dynamic>>(
      data['changelogs'] as List<dynamic>,
    );

    final List<Changelog> changelogs =
        changelogsmapslist.map((Map<String, dynamic> changelog) {
      return Changelog.fromJson(changelog);
    }).toList();

    changelogs.sort((Changelog a, Changelog b) {
      final DateTime aDate = a.updatedOn;
      final DateTime bDate = b.updatedOn;
      return bDate.compareTo(aDate);
    });

    return changelogs;
  },
);

class ChangelogslinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.height);

    double dashWidth = 20;
    double dashSpace = 5;
    double distance = 0;
    Path dashPath = Path();

    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(
            distance,
            distance + dashWidth,
          ),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
