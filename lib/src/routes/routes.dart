import 'package:chaseapp/src/modules/auth/view/pages/auth_view_wrapper.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/modules/profile/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/src/modules/splash_screen/view/pages/splash_page.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/modules/signin/view/pages/signin_page.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const Splash());
      case RouteName.AuthViewWrapper:
        return MaterialPageRoute(builder: (context) => AuthViewWrapper());
      case RouteName.USER_LOGIN:
        return MaterialPageRoute(builder: (_) => LogInView());
      case RouteName.Home:
        return MaterialPageRoute(builder: (_) => Home());
      case RouteName.Profile:
        return MaterialPageRoute(
            builder: (_) => ProfilePage(
                  userName: '',
                  email: '',
                  key: UniqueKey(),
                ));
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Image.asset('assets/images/error.jpg'),
                  Text(
                    "${settings.name} does not exists!",
                    style: const TextStyle(fontSize: 24.0),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }
}
