import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';
import '../../../../shared/widgets/loaders/loading.dart';

final FutureProvider<String> splashScreenAnimationFutureProvider =
    FutureProvider<String>((FutureProviderRef<String> ref) async {
  final FirebaseRemoteConfig remoteConfig =
      ref.read(firebaseRemoteConfigProvider);
  bool isUpdated = await remoteConfig.activate();
  String animationUrl = remoteConfig.getString('splash_screen_animation_url');
  if (animationUrl.isEmpty) {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 3),
        minimumFetchInterval: const Duration(),
      ),
    );
    await remoteConfig.fetch();
    isUpdated = await remoteConfig.activate();
  }
  log('ANimation Url--->$isUpdated');

  animationUrl = remoteConfig.getString('splash_screen_animation_url');

  return animationUrl;
});

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final Logger logger = Logger('SplashView');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precachePicture(
      SvgPicture.asset('assets/icon/google.svg').pictureProvider,
      context,
    );
    precachePicture(
      SvgPicture.asset('assets/icon/apple.svg').pictureProvider,
      context,
    );
    precachePicture(
      SvgPicture.asset('assets/icon/facebook.svg').pictureProvider,
      context,
    );
    precachePicture(
      SvgPicture.asset('assets/icon/twitter.svg').pictureProvider,
      context,
    );
    precachePicture(
      SvgPicture.asset('assets/icon/nodle.svg').pictureProvider,
      context,
    );
    precachePicture(
      SvgPicture.asset(donutSVG).pictureProvider,
      context,
    );
    precacheImage(
      const AssetImage(defaultAssetChaseImage),
      context,
      onError: (Object e, StackTrace? s) {
        log('Catching Error', error: e);
      },
    );
    precacheImage(const AssetImage(chaseAppNameImage), context);
    precacheImage(const AssetImage(chaseAppLogoAssetImage), context);

    Sizescaleconfig.setSizes(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).textScaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) {
        return Scaffold(
          backgroundColor: Colors.blueGrey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      chaseAppTextLogoAsset,
                      height: kImageSizeSmall,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, _) {
                  final AsyncValue<String> splashAnimationLoader =
                      ref.watch(splashScreenAnimationFutureProvider);

                  return splashAnimationLoader.when(
                    data: (String animationUrl) {
                      return Center(
                        child: Lottie.network(
                          animationUrl,
                          errorBuilder: (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) {
                            logger.severe(
                              'Error in loading splash screen animation',
                              error,
                              stackTrace,
                            );
                            Timer(const Duration(milliseconds: 300), () async {
                              final User? user =
                                  await ref.read(streamLogInStatus.future);
                              await Navigator.of(context).pushReplacementNamed(
                                user != null
                                    ? RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER
                                    : RouteName.ONBOARDING_VIEW,
                              );
                            });
                            return const Center(
                              child: CircularAdaptiveProgressIndicatorWithBg(),
                            );
                          },
                          onLoaded: (LottieComposition composition) {
                            // TODO: Control the timer from Firebase as well
                            Timer(const Duration(seconds: 4), () async {
                              final User? user =
                                  await ref.read(streamLogInStatus.future);
                              await Navigator.of(context).pushReplacementNamed(
                                user != null
                                    ? RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER
                                    : RouteName.ONBOARDING_VIEW,
                              );
                            });
                          },
                        ),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularAdaptiveProgressIndicatorWithBg(),
                      );
                    },
                    error: (Object error, StackTrace? stackTrace) {
                      logger.severe(
                        'Error in loading splash screen animation',
                        error,
                        stackTrace,
                      );

                      return Center(
                        child: Lottie.asset(
                          'assets/splash_screen_lottie_animation.json',
                          onLoaded: (LottieComposition composition) {
                            // TODO: Control the timer from Firebase as well
                            Timer(const Duration(seconds: 4), () async {
                              final User? user =
                                  await ref.read(streamLogInStatus.future);
                              await Navigator.of(context).pushReplacementNamed(
                                user != null
                                    ? RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER
                                    : RouteName.ONBOARDING_VIEW,
                              );
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
