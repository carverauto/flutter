import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chaseapp/src/shared/widgets/buttons/medium_clap_flutter.dart';
import 'package:chaseapp/src/models/chase/record.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:chaseapp/src/shared/widgets/views/showurls.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:chaseapp/pages/chat_page.dart';

class ShowChase extends StatelessWidget {
  // ShowChase(this.observer);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final Record record;

  ShowChase({required Key key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topBar = AppBar(
      // backgroundColor: new Color(0xfff8faf8),
      centerTitle: true,
      elevation: 1.0,
      // leading: new Icon(Icons.arrow_back_ios),
      leading: IconButton(
          icon: const Icon(
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
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () => _onShare(context))),
      ],
    );

    return Scaffold(appBar: topBar, body: _stream(record, context));
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(record.Desc, subject: record.Name);
  }

  StreamBuilder _stream(Record record, BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chases')
          .doc(record.ID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return _sizedBox(
            context, snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
      },
    );
  }
  /*
  Padding(
  padding: const EdgeInsets.all(0.3),
  child: URLView(record.Networks as List<Map>),
  ),
   */

  Widget _showNetworks() {
    if (record.Networks != null) {
      return URLView(record.Networks as List<Map>);
    }
    return const Text('Please wait..');
  }

  Widget buildNetworks(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(0.3), child: _showNetworks());
  }

  Widget _sizedBox(BuildContext context, DocumentSnapshot snapshot) {
    var deviceSize = MediaQuery.of(context).size;
    Record record =
        Record.fromSnapshot(snapshot as DocumentSnapshot<Map<String, dynamic>>);
    var imageURL = 'https://chaseapp.tv/police.gif';

    if (record.ImageURL.isNotEmpty) {
      imageURL = record.ImageURL.replaceAll(
          RegExp(
            r"\.([0-9a-z]+)(?:[?#]|$)",
            caseSensitive: false,
            multiLine: false,
          ),
          '_1200x600.webp?');
    }

    // TODO: FIX - BROKEN
    // Support showing the network URL/icon in the chase Details screen
    const ChaseLogo =
        'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chaseapplogo-512.png?alt=media&token=15820729-b6a4-4199-ba2b-a74e87b5c6ca';
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
            Stack(children: <Widget>[
              const Center(child: CircularProgressIndicator()),
              Center(
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage, image: imageURL)),
            ]),
            ListTile(
                title: Text(record.Name,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(record.Desc),
                trailing: Text(record.Votes.toString() + ' donuts')),
            const Divider(),
            buildNetworks(context),
            Container(
                padding: const EdgeInsets.all(30),
                child: Align(
                    alignment: const FractionalOffset(1.0, 0.2),
                    child: ClapFAB.image(
                      clapFabCallback: (int counter) => FirebaseFirestore
                          .instance
                          .runTransaction((transaction) async {
                        final chaseDocRef = FirebaseFirestore.instance
                            .collection('chases')
                            .doc(record.ID);
                        final freshSnapshot =
                            await transaction.get(chaseDocRef);
                        final fresh = Record.fromSnapshot(freshSnapshot
                            as DocumentSnapshot<Map<String, dynamic>>);
                        transaction
                            .update(chaseDocRef, {'Votes': fresh.Votes + 1});
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
