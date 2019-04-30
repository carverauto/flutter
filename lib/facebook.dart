import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:chaseapp/topbar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  var profileData;

  var facebookLogin = FacebookLogin();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return Scaffold(
      // appBar: TopBar(context),
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        centerTitle: true,
        elevation: 1.0,
        // leading: new Icon(Icons.camera_alt),
        title:
            SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
        leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () => facebookLogin.isLoggedIn
                .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
          ),
        ],
      ),
      /* AppBar(
          title: Text("Facebook Login"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => facebookLogin.isLoggedIn
                  .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
            ),
          ],
        ),
        */
      body: Container(
        child: Center(
          child: isLoggedIn
              ? _displayUserData(profileData)
              : _displayLoginButton(),
        ),
      ),
    );
  }

  void initiateFacebookLogin() async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        await analytics.logLogin();
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profileData: profile);
        break;
    }
  }

  _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  _displayLoginButton() {
    return RaisedButton(
      child: Text("Login with Facebook"),
      onPressed: () => initiateFacebookLogin(),
    );
  }

  _logout() async {
    await facebookLogin.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }
}
