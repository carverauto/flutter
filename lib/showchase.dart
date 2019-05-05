import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medium_clap_flutter/medium_clap_flutter.dart';
import 'package:share/share.dart';
import 'package:chaseapp/record.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:chaseapp/showurls.dart';
// import 'package:firebase_analytics/observer.dart';

// import 'package:chaseapp/topbar.dart';

class ShowChase extends StatelessWidget {
  // ShowChase(this.observer);

  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final Record record;

  ShowChase({Key key, @required this.record}) : super(key: key);

/*
  Widget _buildUrlItem(BuildContext context, DocumentSnapshot data) {
    // final OtherURL = Record.fromSnapshot(data);
    final foo = Record.fromSnapshot(record.OtherURL.getDocuments())
  }
  */
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
                  Share.share(record.url,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                })),
        /*
        */
      ],
    );

    return new Scaffold(
      appBar: topBar,
      body: new SizedBox(
          // height: 300,
          height: deviceSize.height,
          child: Card(
              child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(record.name,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(record.desc),
                  trailing: Text(record.votes.toString() + ' donuts')),
              Divider(),
              Padding(
                  // padding: EdgeInsets.all(0.3),
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 25.0, 5.0),
                  child: Linkify(onOpen: _onOpen, text: record.url)),
              Padding(
                padding: EdgeInsets.all(0.3),
                // Linkify(onOpen: _onOpen, text: Text(record.URLs.toList())),
                // child: Text(record.URLs.toString())
                child: URLView(record.urls),
                // child: <Widget>[URLView(record.URLs)]),
              ),
              Container(
                  padding: EdgeInsets.all(30),
                  child: Align(
                      alignment: FractionalOffset(1.0, 0.2),
                      child: ClapFAB.image(
                        clapFabCallback: (int counter) => Firestore.instance
                                .runTransaction((transaction) async {
                              final freshSnapshot =
                                  await transaction.get(record.reference);
                              final fresh = Record.fromSnapshot(freshSnapshot);
                              await transaction.update(
                                  record.reference, {'votes': fresh.votes + 1});
                              counter = fresh.votes;
                            }),
                        defaultImage: "images/donut.png",
                        filledImage: "images/donut.png",
                        countCircleColor: Colors.pink,
                        hasShadow: true,
                        sparkleColor: Colors.red,
                        shadowColor: Colors.pink,
                        defaultImageColor: Colors.pink,
                        filledImageColor: Colors.pink,
                      ))),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a comment...",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ))),
      /*
      // broken
      floatingActionButton: FloatingActionButton(
        child: ClapFAB.image(
          clapFabCallback: (int counter) =>
              Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(record.reference);
                final fresh = Record.fromSnapshot(freshSnapshot);
                await transaction
                    .update(record.reference, {'Votes': fresh.Votes + 1});
                counter = fresh.Votes;
              }),
          defaultImage: "images/donut.png",
          filledImage: "images/donut.png",
          countCircleColor: Colors.pink,
          hasShadow: true,
          sparkleColor: Colors.red,
          shadowColor: Colors.black,
          defaultImageColor: Colors.pink,
          filledImageColor: Colors.pink,
        ),
      ),
      */
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
