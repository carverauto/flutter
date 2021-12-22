import 'package:chaseapp/pages/home_page.dart';
import 'package:chaseapp/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/pages/splash_page.dart';
import 'package:chaseapp/helper/routeNames.dart';
import 'package:chaseapp/pages/signin_page.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    void _toggleView() {
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const Splash());
      case RouteName.USER_LOGIN:
        return MaterialPageRoute(builder: (_) => SignInPage(toggleView: _toggleView,));
      case RouteName.Home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case RouteName.Profile:
        return MaterialPageRoute(builder: (_) => ProfilePage(userName: '', email: '', key: UniqueKey(),));
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

