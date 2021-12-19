import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medium_clap_flutter/medium_clap_flutter.dart';
import 'package:share/share.dart';
import 'package:chaseapp/helper/record.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:chaseapp/widgets/showurls.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:chaseapp/pages/chat_page.dart';


class ShowChase extends StatelessWidget {
  // ShowChase(this.observer);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final Record record;

  ShowChase({Key key, @required this.record}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final topBar = new AppBar(
      // backgroundColor: new Color(0xfff8faf8),
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
      title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 12.0),
            // child: Icon(Icons.share),
            child: IconButton(
                icon: new Icon(Icons.share, color: Colors.black),
                onPressed: () {
                  // analytics.logViewItem(); // #TODO: need tk update this
                  final RenderBox box = context.findRenderObject();
                  // Share.share("ChaseApp - record.LiveURL");
                  // TODO: fix, this is broken...
                  // Share.share(record.Networks, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                })),
      ],
    );

    return new Scaffold(appBar: topBar, body: _stream(record, context));
  }

  StreamBuilder _stream(Record record, BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('chases').doc(record.ID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _sizedBox(context, snapshot.data);
      },
    );
  }

  Widget _sizedBox(BuildContext context, DocumentSnapshot snapshot) {
    var deviceSize = MediaQuery.of(context).size;
    Record record = Record.fromSnapshot(snapshot);


    // TODO: FIX - BROKEN
    // Support showing the network URL/icon in the chase Details screen
    final _ChaseLogo = 'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chaseapplogo-512.png?alt=media&token=15820729-b6a4-4199-ba2b-a74e87b5c6ca';
    /*
    var _networkURL, _networks;

    if (record.Networks != null) {
      var myMap = Map<String, dynamic>.from(record.Networks);
      _networkURL = myMap['URL'];
      _network = myMap['name'];
    } else {
      _networkURL = _ChaseLogo;
      _network = "";
    }
     */

    return SizedBox(
        height: deviceSize.height,
        child: SingleChildScrollView(
            child: Column(
              // child: SingleChildScrollView(
              children: <Widget>[
                ListTile(title: Text(record.Name, style: TextStyle(fontWeight: FontWeight.w500)), subtitle: Text(record.Desc), trailing: Text(record.Votes.toString() + ' donuts')),
                Divider(),
                /*
                Container(
                  child:
                      ListTile(
                        leading: // Shimmer.fromColors(
                            // child:
                          CircleAvatar(
                              radius: 25,
                              // backgroundColor: Colors.black38,
                              backgroundColor: Colors.transparent,
                              child: Material(
                                clipBehavior: Clip.hardEdge,
                                shape: CircleBorder(),
                                color: Colors.transparent,
                                child:
                              CachedNetworkImage(
                                  imageUrl: _networkURL
                                ),
                              ),
                            ),
                            // baseColor: Colors.transparent,
                            // highlightColor: Colors.redAccent,
                        title: Linkify(onOpen: _onOpen, text: record.Networks),
                      ),
                ),

                 */
                  //),
                Padding(
                  padding: EdgeInsets.all(0.3),
                  child: URLView(record.Networks),
                ),
                Container(
                    padding: EdgeInsets.all(30),
                    child: Align(
                        alignment: FractionalOffset(1.0, 0.2),
                        child: ClapFAB.image(
                          clapFabCallback: (int counter) => FirebaseFirestore.instance.runTransaction((transaction) async {
                            final freshSnapshot = await transaction.get(record.reference);
                            final fresh = Record.fromSnapshot(freshSnapshot);
                            transaction.update(record.reference, {'Votes': fresh.Votes + 1});
                            counter = fresh.Votes;
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
                // VxBox(  ).square(350).gray300.make()
                SizedBox(
                  width: 400,
                  height: 350,
                  // child: ChatScreen(record.ID),
                   // child: ChatView(record.ID), // #TODO: bring chat stuff back in
                  // child: SingleChildScrollView( child: ChatScreen(record.ID))
                )
                //ChatScreen('Foo'),
              ],
            )));
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

}

class Network {
  String URL;
  String name;
}

