import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/images.dart';
import '../../../bof/bof_view.dart';
import '../../../map/map_view.dart';
import '../../../notifications/view/parts/notifications_appbar_button.dart';

class ChaseAppBar extends ConsumerStatefulWidget {
  const ChaseAppBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ChaseAppBar> createState() => _ChaseAppBarState();
}

class _ChaseAppBarState extends ConsumerState<ChaseAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<double> appBarMaxHeightAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final double width = MediaQuery.of(context).size.width;

    appBarMaxHeightAnimation = Tween<double>(
      begin: width / (16 / 9),
      end: MediaQuery.of(context).size.height,
    )
        .chain(
          CurveTween(
            curve: Curves.decelerate,
          ),
        )
        .animate(animationController);
  }

  void extendTheMap() {
    if (!animationController.isAnimating && !animationController.isCompleted) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isBOFActiveProvider, (bool? prev, bool next) {
      if (next != null) {
        final double width = MediaQuery.of(context).size.width;

        appBarMaxHeightAnimation = Tween<double>(
          begin: width / (16 / 9),
          end: MediaQuery.of(context).size.height + (next ? -150 : 0),
        )
            .chain(
              CurveTween(
                curve: Curves.decelerate,
              ),
            )
            .animate(animationController);
        if (animationController.isCompleted) {
          animationController
            ..reset()
            ..forward();
        }
      }
    });

    return AnimatedBuilder(
      animation: animationController,
      child: MapBoxView(
        onSymbolTap: extendTheMap,
        onExpansionButtonTap: () {
          if (animationController.isAnimating) {
            return;
          }
          if (animationController.isCompleted) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        },
      ),
      builder: (BuildContext context, Widget? map) {
        return SliverAppBar(
          centerTitle: true,
          // backgroundColor: Colors.transparent,
          title: const ChaseAppLogoImage(),
          floating: true,
          expandedHeight: appBarMaxHeightAnimation.value,
          flexibleSpace: FlexibleSpaceBar(
            background: AspectRatio(
              aspectRatio: 16 / 9,
              // GEstureDetector won't work?
              child: map!,
            ),
          ),
          actions: const [
            NotificationsAppbarButton(),
          ],
        );
      },
    );
  }
}

class ChaseAppLogoImage extends StatelessWidget {
  const ChaseAppLogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      chaseAppNameImage,
      color: Colors.white,
      cacheHeight: 60,
      cacheWidth: 478,
    );
  }
}
