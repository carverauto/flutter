import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../../shared/widgets/brand/chaseapp_brand_widgets.dart';
import '../../../bof/bof_view.dart';
import '../../../map/map_view.dart';
import '../../../notifications/view/parts/notifications_appbar_button.dart';

class ChaseAppBar extends ConsumerStatefulWidget {
  const ChaseAppBar({
    super.key,
    required this.onMapExpansion,
  });

  final Function(bool value) onMapExpansion;

  @override
  ConsumerState<ChaseAppBar> createState() => _ChaseAppBarState();
}

class _ChaseAppBarState extends ConsumerState<ChaseAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<double> appBarMaxHeightAnimation;

  void updateOnMapExpansionStatus() {
    if (animationController.isCompleted) {
      widget.onMapExpansion(true);
    }
    if (animationController.isDismissed) {
      widget.onMapExpansion(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animationController.addListener(updateOnMapExpansionStatus);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final double width = MediaQuery.of(context).size.width;
    final bool isBOFActive = ref.read(isBOFActiveProvider);
    final double minHeight =
        width / (16 / 9) > MediaQuery.of(context).size.height * 0.4
            ? MediaQuery.of(context).size.height * 0.4
            : width / (16 / 9);

    appBarMaxHeightAnimation = Tween<double>(
      begin: minHeight,
      end: MediaQuery.of(context).size.height - (isBOFActive ? 150 : 0),
    )
        .chain(
          CurveTween(
            curve: Curves.decelerate,
          ),
        )
        .animate(animationController);
  }

  void extendTheMap(String? symbolId, LatLng? latLng) {
    if (io.Platform.isAndroid) {
      navigateToMapFullView(context, symbolId, latLng);
      return;
    }
    if (!animationController.isAnimating && !animationController.isCompleted) {
      animationController.forward();
    }
  }

  void navigateToMapFullView(
    BuildContext context, [
    String? symbolId,
    LatLng? latlng,
  ]) {
    if (!Navigator.canPop(context)) {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MapBoxView(
              symbolId: symbolId,
              latLng: latlng,
              onSymbolTap: (
                String? id,
                LatLng? latLng,
              ) {},
              showAppBar: true,
              animation: const AlwaysStoppedAnimation(0),
              onExpansionButtonTap: () {},
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.removeListener(updateOnMapExpansionStatus);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isBOFActiveProvider, (bool? prev, bool next) {
      if (next != null) {
        final double width = MediaQuery.of(context).size.width;
        final double minHeight =
            width / (16 / 9) > MediaQuery.of(context).size.height * 0.4
                ? MediaQuery.of(context).size.height * 0.4
                : width / (16 / 9);

        appBarMaxHeightAnimation = Tween<double>(
          begin: minHeight,
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
    const ChaseAppNameLogoImage title = ChaseAppNameLogoImage();
    const NotificationsAppbarButton notificationButton =
        NotificationsAppbarButton();

    return AnimatedBuilder(
      animation: animationController,
      child: FlexibleSpaceBar(
        background: MapBoxView(
          onSymbolTap: extendTheMap,
          animation: animationController.view,
          onExpansionButtonTap: () {
            if (io.Platform.isAndroid) {
              navigateToMapFullView(context);
              return;
            }

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
      ),
      builder: (BuildContext context, Widget? map) {
        return SliverAppBar(
          centerTitle: true,
          // backgroundColor: Colors.transparent,
          title: title,
          // floating: true,
          expandedHeight: appBarMaxHeightAnimation.value,
          flexibleSpace: map,
          actions: const [
            notificationButton,
          ],
        );
      },
    );
  }
}
