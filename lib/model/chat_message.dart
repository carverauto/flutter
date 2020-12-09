// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String username;
  int timestamp;
  final AnimationController animationController;

  ChatMessage({
    String text,
    String imageUrl,
    String username,
    int timestamp,
    AnimationController animationController,
  })  : text = text,
        imageUrl = imageUrl,
        username = username,
        timestamp = timestamp,
        animationController = animationController;

  Map<String, dynamic> toMap() => imageUrl == null ? {'text': text, 'username': username, 'timestamp': timestamp} : {'imageUrl': imageUrl, 'username': username};

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                // #TODO: show circleavatar with first letter of username or profilePic if exists
                child: CircleAvatar(child: Text(username[0])),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(username, style: Theme.of(context).textTheme.subtitle1),
                    Text(username, style: Theme.of(context).textTheme.bodyText1),
                    // Text(DateFormat("hh:mm:ss").format(DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000)).toString()),
                    Container(
                      // child: Text(username, style: Theme.of(context).textTheme.subhead),
                      child: Text(DateFormat("hh:m").format(DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000)).toString()),
                      alignment: Alignment.topRight,
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: imageUrl == null ? Text(text) : Image.network(imageUrl),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
