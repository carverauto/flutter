import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
// import 'package:chaseapp/datetime.dart';
import 'package:chaseapp/showchase.dart';
import 'package:chaseapp/record.dart';
import 'package:chaseapp/topbar.dart';
import 'package:chaseapp/fbcm.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChaseApp.IO',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(color: Colors.black),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
          textTheme: TextTheme(title: TextStyle(color: Colors.black))),
      navigatorObservers: <NavigatorObserver>[observer],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState(analytics, observer);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    setMessage('logEvent succeeded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chaseStream,
      // stream: Firestore.instance.collection('chases').snapshots(),
      /*
      stream: Firestore.instance
          .collection('chases')
          .orderBy('CreatedAt', descending: true)
          .snapshots(),
          */
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    // var record = Record.fromSnapshot(data);

    var chaseDate = DateTime.parse(record.CreatedAt.toIso8601String());
    var today = new DateTime.now().toLocal();
    var diff = chaseDate.difference(today);
    // print("URLs " + record.urls.toString());

    var dateMsg = '';

    if (record.Live) {
      dateMsg = 'LIVE!';
    } else if (diff.inDays.abs() == 0) {
      // Was the chase today?
      if (diff.inHours.abs() == 0) {
        // Chase in last hour?
        if (diff.inMinutes == 0) {
          // In the last minute? show seconds
          dateMsg = diff.inSeconds.abs().toString() + ' seconds ago';
        } else {
          // Otherwise show how many minutes
          dateMsg = diff.inMinutes.abs().toString() + ' minutes ago';
        }
      } else if (diff.inHours.abs() == 1) {
        // One hour ago
        dateMsg = diff.inHours.abs().toString() + ' hour ago';
      } else if (diff.inHours.abs() > 1) {
        // Hours ago
        dateMsg = diff.inHours.abs().toString() + ' hours ago';
      }
    } else {
      // More than a day ago, just print the date
      dateMsg = chaseDate.toIso8601String().substring(0, 10);
    }

    return Padding(
      key: ValueKey(record.Name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            leading: new CircleAvatar(
              backgroundColor: Colors.white,
              child: record.Live ? _displayLiveIcon() : _displayVideoIcon(),
            ),
            title: Text(record.Name),
            // subtitle: Text(record.Votes.toString() + ' donuts'),
            subtitle: Text(dateMsg),
            trailing: new Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.pink[50],
                child: new Image(
                  image: new AssetImage("images/donut.png"),
                ),
              ),
              label: Text(record.Votes.toString()),
            ),
            /*
            trailing: new CircleAvatar(
                backgroundColor: Colors.pink,
                child: new Image(
                  image: new AssetImage("images/donut.jpg"),
                )),
                */
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowChase(record: record)))
                }),
      ),
    );
  }

//  Stream<Snapshot> chaseStream;
  Stream<QuerySnapshot> chaseStream;
  @override
  void initState() {
    super.initState();
    chaseStream = Firestore.instance
        .collection('chases')
        .orderBy('CreatedAt', descending: true)
        .snapshots();
    print('in initState');
    firebaseCloudMessaging_Listeners();
  }
} // _myHomePageState

_displayLiveIcon() {
  return new Image(image: new AssetImage("images/broadcast.png"));
}

_displayVideoIcon() {
  return new Image(image: new AssetImage("images/video.png"));
}
