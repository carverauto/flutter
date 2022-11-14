import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../core/top_level_providers/firebase_providers.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';
import '../../../../shared/widgets/loaders/loading.dart';

final FutureProvider<String> splashScreenAnimationFutureProvider =
    FutureProvider<String>((FutureProviderRef<String> ref) async {
  final Stopwatch timer = Stopwatch()..start();
  final FirebaseRemoteConfig remoteConfig =
      ref.read(firebaseRemoteConfigProvider);
  bool isUpdated = true;
  String animationUrl = remoteConfig.getString('splash_screen_animation_url');
  if (animationUrl.isEmpty) {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 2),
        minimumFetchInterval: const Duration(),
      ),
    );
    await remoteConfig.fetch();
    isUpdated = await remoteConfig.activate();
  }
  log('ANimation Url--->$isUpdated');

  animationUrl = remoteConfig.getString('splash_screen_animation_url');
  final String animationUrlFilename = path.basename(animationUrl);

  final Directory tempDirPath = await getTemporaryDirectory();
  final String assetAnimationJsonPath =
      path.join(tempDirPath.path, animationUrlFilename);
  final File locallyStoredAnimationFile = File(assetAnimationJsonPath);
  final bool fileExists = locallyStoredAnimationFile.existsSync();
  if (!fileExists) {
    // download the animationUrl file
    // and save it to assetAnimationJsonPath
    final http.Response downloadedBytes =
        await http.get(Uri.parse(animationUrl));

    final File animationAssetFile = locallyStoredAnimationFile;
    await animationAssetFile.writeAsBytes(downloadedBytes.bodyBytes);
    await animationAssetFile.create();
  }
  timer.stop();
  log('Firebase Timer--->${timer.elapsedMilliseconds}');

  return assetAnimationJsonPath;
});

class SplashView extends ConsumerStatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  final Logger logger = Logger('SplashView');

  late Timer timer;

  void updateTimer(Duration duration) {
    timer.cancel();
    timer = Timer(duration, () async {
      final User? user = await ref.read(streamLogInStatus.future);
      if (mounted) {
        await Navigator.of(context).pushReplacementNamed(
          user != null
              ? RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER
              : RouteName.ONBOARDING_VIEW,
        );
      }
    });
  }

  void onSpalshScreenLoad(LottieComposition composition) {
    // TODO: Control the timer from Firebase as well
    timer.cancel();
    Timer(const Duration(seconds: 3), () async {
      final User? user = await ref.read(streamLogInStatus.future);
      if (mounted) {
        await Navigator.of(context).pushReplacementNamed(
          user != null
              ? RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER
              : RouteName.ONBOARDING_VIEW,
        );
      }
    });
  }

  Widget onSpalshScreenLoadError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    logger.severe(
      'Error in loading splash screen animation',
      error,
      stackTrace,
    );
    updateTimer(
      const Duration(milliseconds: 300),
    );

    return const Center(
      child: CircularAdaptiveProgressIndicatorWithBg(),
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {});
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
                      timer.cancel();

                      return Center(
                        child: Theme.of(context).platform == TargetPlatform.iOS
                            ? Lottie.asset(
                                animationUrl,
                                errorBuilder: onSpalshScreenLoadError,
                                onLoaded: onSpalshScreenLoad,
                              )
                            : Lottie.file(
                                File(animationUrl),
                                errorBuilder: onSpalshScreenLoadError,
                                onLoaded: onSpalshScreenLoad,
                              ),
                      );
                    },
                    loading: () {
                      updateTimer(
                        const Duration(seconds: 3),
                      );

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
                      updateTimer(const Duration(milliseconds: 300));

                      return const Center(
                        child: CircularAdaptiveProgressIndicatorWithBg(),
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
