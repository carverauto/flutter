import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateNotifierBuilder.dart';
import 'package:chaseapp/src/shared/widgets/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends ConsumerWidget {
  Dashboard({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.read(chasesPaginatedStreamProvider.notifier).fetchNextPage();
      }
    });
    return Scaffold(
      body: NestedScrollView(
        // controller: controller,
        //               restorationId: "Chases List",
        //               padding: const EdgeInsets.symmetric(
        //                 vertical: kPaddingMediumConstant,
        //                 horizontal: kPaddingMediumConstant,
        //               ),
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              centerTitle: true,
              elevation: kElevation,
              pinned: true,
              title: Image.asset(chaseAppNameImage),
              actions: [
                IconButton(
                  icon: CircleAvatar(
                    radius: kImageSizeMedium,
                    backgroundImage: CachedNetworkImageProvider(
                        ref.read(firebaseAuthProvider).currentUser?.photoURL ??
                            'defaultPhotoURL'),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    // context, MaterialPageRoute(builder: (context) => Settings()))),
                    context,
                    RouteName.PROFILE,
                  ),
                ),
              ],
            )
          ];
        },
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            // Error if removed (Need to report)
            SliverToBoxAdapter(
              child: SizedBox(
                height: kPaddingMediumConstant,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
              sliver: ProviderStateNotifierBuilder<List<Chase>>(
                  watchThisStateNotifierProvider: chasesPaginatedStreamProvider,
                  scrollController: scrollController,
                  builder: (chases, controller, [Widget? bottomWidget]) {
                    log(chases.length.toString());

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final chase = chases[index];

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: kPaddingMediumConstant,
                            ),
                            child: ChaseTile(chase: chase),
                          );
                        },
                        childCount: chases.length,
                      ),
                    );
                  }),
            ),
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, ref, _) {
                  return ref.watch(chasesPaginatedStreamProvider).maybeWhen(
                        data: (chases, canLoad) {
                          final isFetching = ref
                              .read(chasesPaginatedStreamProvider.notifier)
                              .isFetching;
                          final onGoingState = ref
                              .read(chasesPaginatedStreamProvider.notifier)
                              .onGoingState;
                          return BottomWidget(
                            isFetching: isFetching,
                            onGoingState: onGoingState,
                            watchThisStateNotifierProvider:
                                chasesPaginatedStreamProvider,
                          );
                        },
                        orElse: () => SizedBox.shrink(),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChaseTile extends StatelessWidget {
  const ChaseTile({
    Key? key,
    required this.chase,
  }) : super(key: key);

  final Chase chase;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: kBorderSideWidthSmallConstant,
          ),
          borderRadius: BorderRadius.circular(kBorderRadiusSmallConstant),
        ),
        title: Text(chase.name ?? "NA", style: GoogleFonts.getFont('Poppins')),
        subtitle: Text(dateAdded(chase)),
        trailing: Chip(
          elevation: kElevation,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          avatar: SvgPicture.asset(donutSVG),
          label: Text(
            chase.votes.toString(),
          ),
        ),
        onTap: () {
          // Navigator.pushNamed(
          //   context,
          //   RouteName.CHASE_VIEW,
          //   arguments: {
          //     "chase": chase,
          //   },
          // );
        });
  }
}
