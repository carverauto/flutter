// ignore_for_file: public_member_api_docs, avoid_classes_with_only_static_members, omit_local_variable_types, cast_nullable_to_non_nullable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const/other.dart';
import '../core/modules/auth/view/pages/auth_view_wrapper.dart';
import '../core/notifiers/pagination_notifier.dart';
import '../models/chase/chase.dart';
import '../models/pagination_state/pagination_notifier_state.dart';
import '../modules/about/view/about.dart';
import '../modules/change_logs/view/change_logs.dart';
import '../modules/chase_view/view/pages/chaseDetails_page.dart';
import '../modules/chases/view/pages/recent_chases/recent_chases_view_all.dart';
import '../modules/check_permissions/view/pages/check_permissions_status.dart';
import '../modules/credits/view/credits.dart';
import '../modules/feedback_form/view/feedback_form.dart';
import '../modules/feedback_form/view/support_view.dart';
import '../modules/firehose/view/pages/firehose_view_all.dart';
import '../modules/home/view/pages/home_wrapper.dart';
import '../modules/in_app_purchases/views/in_app_purchases_settings.dart';
import '../modules/map/view/map_wrapper/map_wrapper.dart';
import '../modules/notifications/view/pages/notifications_view.dart';
import '../modules/onboarding/view/pages/onboarding.dart';
import '../modules/profile/view/pages/profile_page.dart';
import '../modules/settings/view/pages/settings_page.dart';
import '../modules/signin/view/pages/signin_page.dart';
import '../modules/splash_screen/view/pages/splash_page.dart';
import 'routeNames.dart';

class Routes {
  // ignore: long-method
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Map<String, dynamic> arguments = settings.arguments != null
        ? settings.arguments as Map<String, dynamic>
        : <String, dynamic>{};
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const SplashView(),
        );
      case RouteName.ONBOARDING_VIEW:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const OnBoardingView(),
        );
      case RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => CheckPermissionsViewWrapper(),
        );
      // case RouteName.REQUEST_PERMISSIONS_VIEW:
      //   return MaterialPageRoute<void>(
      //     builder: (BuildContext context) => const RequestPermissionsView(),
      //   );
      case RouteName.AUTH_VIEW_WRAPPER:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => AuthViewWrapper(),
        );
      case RouteName.USER_LOGIN:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const LogInView(),
        );
      case RouteName.HOME_WRAPPER:
        return MaterialPageRoute<void>(builder: (_) => HomeWrapper());
      case RouteName.CHASE_VIEW:
        final String chaseId = arguments['chaseId'] as String;
        final Chase? chase = arguments['chase'] as Chase?;

        return _createRoute(
          chaseId,
          chase,
          settings,
        );
      case RouteName.RECENT_CHASESS_VIEW_ALL:
        final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
                PaginationNotifierState<Chase>> chasesPaginationProvider =
            arguments['chasesPaginationProvider']
                as AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
                    PaginationNotifierState<Chase>>;

        return MaterialPageRoute<void>(
          builder: (_) => RecentChasesListViewAll(
            chasesPaginationProvider: chasesPaginationProvider,
          ),
        );
      case RouteName.FIREHOSE_VIEW_ALL:
        return MaterialPageRoute<void>(
          builder: (_) => const FirehoseListViewAll(
            showLimited: false,
          ),
        );
      case RouteName.PROFILE:
        return MaterialPageRoute<bool>(builder: (_) => const ProfileView());
      case RouteName.CREDITS:
        return MaterialPageRoute<bool>(builder: (_) => const CreditsView());
      case RouteName.ABOUT_US:
        return MaterialPageRoute<bool>(builder: (_) => const AboutUsView());
      case RouteName.SETTINGS:
        return MaterialPageRoute<bool>(builder: (_) => SettingsView());
      case RouteName.NOTIFICATIONS:
        return MaterialPageRoute<bool>(builder: (_) => NotificationsView());
      case RouteName.SUPPORT:
        return MaterialPageRoute<bool>(builder: (_) => const SupportView());
      case RouteName.BUG_REPORT:
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (_) => const FeedbackForm(),
        );
      case RouteName.IN_APP_PURCHASES:
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (_) => const InAppPurchasesSettings(),
        );
      case RouteName.SPACEXMAP:
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (_) => const MapViewWrapper(),
        );
      case RouteName.CHANGELOGS:
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (_) => ChangeLogs(),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Image.asset('assets/images/error.jpg'),
                  Text(
                    '${settings.name} does not exists!',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}

Route<void> _createRoute(String chaseId, Chase? chase, RouteSettings settings) {
  return PageRouteBuilder<void>(
    settings: settings,
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      final Animation<Offset> appbarOffsetAnimation = Tween<Offset>(
        begin: const Offset(
          0,
          -kToolbarHeight,
        ),
        end: Offset.zero,
      )
          .chain(
            CurveTween(
              curve: kPrimaryCurve,
            ),
          )
          .animate(animation);
      final Animation<Offset> bottomListAnimation = Tween<Offset>(
        begin: Offset(
          0,
          MediaQuery.of(context).size.height,
        ),
        end: Offset.zero,
      )
          .chain(
            CurveTween(
              curve: kPrimaryCurve,
            ),
          )
          .animate(animation);

      return ChaseDetailsView(
        chaseId: chaseId,
        chase: chase,
        appBarOffsetAnimation: appbarOffsetAnimation,
        bottomListAnimation: bottomListAnimation,
      );
    },
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return child;
    },
  );
}
