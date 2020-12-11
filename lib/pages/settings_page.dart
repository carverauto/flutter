// import 'package:chaseapp/utils/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseApp, FirebaseOptions;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chaseapp/pages/signin_page.dart';
// import 'package:chaseapp/utils/deviceSize.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';


class Settings extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void signOutGoogle() async {
    await _googleSignIn.signOut();
    print("User Sign Out");
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics();

  // ShowChase({Key key, @required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    final topBar = new AppBar(
      backgroundColor: new Color(0xfff8faf8),
      centerTitle: true,
      elevation: 1.0,
      // leading: new Icon(Icons.arrow_back_ios),
      leading: new IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.black,
          ),
          onPressed: () {
            signOutGoogle();
            //Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) { return LoginScreen(); }), ModalRoute.withName('/'));
            Navigator.push(context, new MaterialPageRoute(builder: (context) => new SignInPage()));
          },
        ),
      ],
      title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
    );

    return new Scaffold(
      appBar: topBar,
      body: new SizedBox(
          height: deviceSize.height,
          child: Card(
              child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Divider(),
              Padding(
                // padding: EdgeInsets.all(0.2), child: Text('Notifications')),
                padding: EdgeInsets.all(0.2),
                child: RaisedButton(
                  onPressed: _launchURL,
                  // child: Text('Show Privacy Policy ${FirebaseAuth.instance.currentUser.displayName}'),
                  child: Text('Show Privacy Policy'),
                ),
                // child: LoginPage())
              )
            ],
          ))),
    );
  }
}

_launchURL() async {
  const url = 'https://chaseapp.tv/privacy';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
