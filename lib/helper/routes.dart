import 'package:chaseapp/pages/home_page.dart';
import 'package:chaseapp/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/pages/splash_page.dart';
import 'package:chaseapp/helper/routeNames.dart';
import 'package:chaseapp/pages/signin_page.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Splash());
      case RouteName.USER_LOGIN:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case RouteName.Home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case RouteName.Profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
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
                    style: TextStyle(fontSize: 24.0),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }
}

