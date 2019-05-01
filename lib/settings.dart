import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
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
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
      /*
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 12.0),
            // child: Icon(Icons.share),
            child: IconButton(
                icon: new Icon(Icons.share),
                onPressed: () {
                  analytics.logViewItem();
                  final RenderBox box = context.findRenderObject();
                  // Share.share("ChaseApp - record.LiveURL");
                  Share.share(record.LiveURL,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                }))
      ],
      */
    );

    return new Scaffold(
      appBar: topBar,
      body: new SizedBox(),
    );
  }
}
