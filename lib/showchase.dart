import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medium_clap_flutter/medium_clap_flutter.dart';
import 'package:share/share.dart';
import 'package:chaseapp/record.dart';
import 'package:chaseapp/topbar.dart';

class ShowChase extends StatelessWidget {
  final Record record;

  ShowChase({Key key, @required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  final RenderBox box = context.findRenderObject();
                  // Share.share("ChaseApp - record.LiveURL");
                  Share.share(record.LiveURL,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                }))
      ],
    );

    return new Scaffold(
      //appBar: new AppBar( title: new Text('Chase Details'),),
      appBar: topBar,
      body: new SizedBox(
          height: 300,
          child: Card(
              child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(record.Name,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(record.Desc),
                  trailing: Text(record.Votes.toString() + ' donuts')),
              Divider(),
              Padding(
                  padding: EdgeInsets.all(0.3),
                  child: Linkify(onOpen: _onOpen, text: record.LiveURL)),
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
                                  record.reference, {'Votes': fresh.Votes + 1});
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
                      ))),
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
