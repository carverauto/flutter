import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/dashboard/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateNotifierBuilder.dart';
import 'package:chaseapp/src/shared/widgets/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      floatingActionButton: AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          double scrollOffset = scrollController.offset;
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: scrollOffset > Sizescaleconfig.screenheight! * 0.5
                ? FloatingActionButton(
                    tooltip: "Scroll to top",
                    child: Icon(
                      Icons.arrow_upward,
                    ),
                    onPressed: () {
                      scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                : SizedBox.shrink(),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(chasesPaginatedStreamProvider.notifier).fetchFirstPage(true);
        },
        child: CustomScrollView(
          controller: scrollController,
          restorationId: "Chases List",
          slivers: [
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
            ),
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
                    return chases.isEmpty
                        ? SliverToBoxAdapter(
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(chasesPaginatedStreamProvider
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
                        : SliverList(
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
              child: Align(
                alignment: Alignment.center,
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
          Navigator.pushNamed(
            context,
            RouteName.CHASE_VIEW,
            arguments: {
              "chase": chase,
            },
          );
        });
  }
}
