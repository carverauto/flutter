import 'dart:core';

import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/widgets/buttons/medium_clap_flutter.dart';
import 'package:chaseapp/src/shared/widgets/views/showurls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:chaseapp/pages/chat_page.dart';

class ShowChase extends ConsumerWidget {
  // ShowChase(this.observer);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final Chase record;

  ShowChase({required Key key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Scaffold(
      appBar: topBar,
      body: ref.watch(streamChaseProvider(record.id)).when(
            data: (chase) {
              var deviceSize = MediaQuery.of(context).size;

              var imageURL = 'https://chaseapp.tv/police.gif';

              if (record.imageURL != null) {
                imageURL = record.imageURL!.replaceAll(
                    RegExp(
                      r"\.([0-9a-z]+)(?:[?#]|$)",
                      caseSensitive: false,
                      multiLine: false,
                    ),
                    '_1200x600.webp?');
              }

              return SizedBox(
                  height: deviceSize.height,
                  child: SingleChildScrollView(
                      child: Column(
                    // child: SingleChildScrollView(
                    children: <Widget>[
                      Center(
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage, image: imageURL)),
                      ListTile(
                          title: Text(record.name ?? "NA",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(record.desc ?? "NA"),
                          trailing: Text(record.votes.toString() + ' donuts')),
                      const Divider(),
                      Padding(
                          padding: const EdgeInsets.all(0.3),
                          child: _showNetworks()),
                      Container(
                          padding: const EdgeInsets.all(30),
                          child: Align(
                              alignment: const FractionalOffset(1.0, 0.2),
                              child: ClapFAB.image(
                                clapFabCallback: (int counter) =>
                                    FirebaseFirestore.instance
                                        .runTransaction((transaction) async {
                                  final chaseDocRef = FirebaseFirestore.instance
                                      .collection('chases')
                                      .doc(record.id);
                                  final freshSnapshot =
                                      await transaction.get(chaseDocRef);
                                  final fresh = Chase.fromJson(freshSnapshot
                                      .data() as Map<String, dynamic>);
                                  final votes = fresh.votes ?? 0;
                                  transaction.update(
                                      chaseDocRef, {'Votes': votes + 1});
                                  counter = votes;
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
            },
            error: (e, s) {},
            loading: () => CircularProgressIndicator(),
          ),
    );
  }

  void _onShare(BuildContext context) async {
    await Share.share(record.desc ?? "NA", subject: record.name);
  }

  Widget _showNetworks() {
    if (record.networks != null) {
      return URLView(record.networks as List<Map>);
    }
    return const Text('Please wait..');
  }
}


            // TODO: FIX - BROKEN
            // Support showing the network URL/icon in the chase Details screen
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