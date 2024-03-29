import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// import 'package:device_preview/device_preview.dart';
import 'src/const/colors.dart';
import 'src/const/sizings.dart';
import 'src/core/top_level_providers/services_providers.dart';
import 'src/modules/app_review/app_review_notifier.dart';
import 'src/modules/chats/view/providers/providers.dart';
import 'src/modules/feedback_form/view/feedback_form.dart';
import 'src/modules/in_app_purchases/views/view_helpers.dart';
import 'src/routes/routeNames.dart';
import 'src/routes/routes.dart';
import 'src/shared/util/helpers/request_permissions.dart';
import 'src/shared/widgets/errors/error_widget.dart';
import 'src/theme/theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessangerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorGlobalKey =
    GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ChaseApp',
      scaffoldMessengerKey: scaffoldMessangerKey,
      initialRoute: '/',
      navigatorKey: navigatorGlobalKey,
      builder: (BuildContext context, Widget? child) {
        return StreamChat(
          streamChatThemeData: StreamChatThemeData.dark().copyWith(
            // TODO: Need to debug why?
            // If not added then getStream API is overriding the
            // the user set accentColor in Custom Theme
            colorTheme: StreamColorTheme.dark(
              accentPrimary: primaryColor.shade500,
            ),
          ),
          client: ref.watch(streamChatClientProvider),
          child: Stack(
            fit: StackFit.expand,
            children: [
              RepaintBoundary(
                key: ref.read(appGlobalKeyProvider),
                child: child,
              ),
              const CaptureButton(),
            ],
          ),
        );
      },
      // locale: Locale('en'), // Add the locale here
      // builder: DevicePreview.appBuilder,

      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      navigatorObservers: [
        RoutesObserver(ref),
      ],
      theme: getThemeData(context),
    );
  }
}

class CaptureButton extends ConsumerWidget {
  const CaptureButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCapturing = ref.watch(isCapturingScreenshotFromAppProvider);

    return !isCapturing
        ? const SizedBox.shrink()
        : Positioned(
            bottom: kPaddingMediumConstant,
            right: kPaddingSmallConstant,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () async {
                    ref.read(isCapturingScreenshotFromAppProvider.state).state =
                        false;
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.blue,
                    elevation: 10,
                    fixedSize: const Size.fromHeight(
                      64,
                    ),
                  ),
                  onPressed: () async {
                    final ui.Image image = await takeAppScreenshot(ref);
                    ref
                        .read(
                          capturedSupportAppImageProvider.state,
                        )
                        .update(
                          (ui.Image? state) => image,
                        );
                    ref.read(isCapturingScreenshotFromAppProvider.state).state =
                        false;
                    // get current route name
                    final String? currentPath = ref.read(currentRouteProvider);
                    if (currentPath == null) {
                      await navigatorGlobalKey.currentState!
                          .pushNamed(RouteName.BUG_REPORT);
                    }
                  },
                  child: const Icon(
                    Icons.camera,
                    color: Colors.blue,
                    size: kIconSizeLargeConstant,
                  ),
                ),
              ],
            ),
          );
  }
}

class RoutesObserver extends NavigatorObserver {
  RoutesObserver(
    this.ref,
  );
  final WidgetRef ref;

  final Logger routesObserverLogger = Logger('RoutesObserverLogger');

  @override
  Future<void> didPop(Route route, Route? previousRoute) async {
    // TODO: implement didPop
    if (route.settings.name == RouteName.CHASE_VIEW) {
      Timer(const Duration(milliseconds: 500), () async {
        try {
          if (previousRoute?.navigator?.context != null) {
            await checkRequestPermissions(previousRoute!.navigator!.context);

            if (ref
                .read(appReviewStateNotifier.notifier)
                .shouldShowAskForReviewDialog) {
              await showaskForReviewDialog(
                ref,
                previousRoute.navigator!.context,
              );
            } else if (ref
                .read(appReviewStateNotifier.notifier)
                .shouldShowPremiumDialog) {
              await showInAppPurchasesDialog(
                previousRoute.navigator!.context,
              );
            } else {}
          }
        } catch (e, stk) {
          routesObserverLogger.warning(
            'Error while trying to check for permissions/requesting permissions.',
            e,
            stk,
          );
        }
      });
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
    super.didPush(route, previousRoute);
    if (route.settings.name == RouteName.CHASE_VIEW) {
      ref.read(appReviewStateNotifier.notifier).updatechasesSeenCount();
    }
  }
}

Future<void> setUpServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());

  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 12),
    ),
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }

    return Material(
      child: Center(
        child: ChaseAppErrorWidget(
          message: "Oops! This isn't good.",
          onRefresh: () {},
        ),
      ),
    );
  };

  Logger.root.onRecord.listen((LogRecord record) {
    FirebaseCrashlytics.instance.recordError(
      '${record.loggerName} : ${record.message}',
      record.stackTrace,
      reason: record.error,
      fatal: record.level == Level.SEVERE,
    );
  });
}

class ProvidersLogger extends ProviderObserver {
  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    log(
      '''
{
  "provider": "${provider.name ?? provider.runtimeType}"
}''',
    );
  }
}
