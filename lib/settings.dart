// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chaseapp/login_page.dart';
import 'package:chaseapp/sign_in.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:chaseapp/facebook.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:firebase_analytics/observer.dart';

// import 'package:chaseapp/topbar.dart';

class Settings extends StatelessWidget {
  // ShowChase(this.observer);

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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
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
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) { return LoginPage();}), ModalRoute.withName('/'));
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