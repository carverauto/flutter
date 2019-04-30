import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:chaseapp/facebook.dart';
import 'package:chaseapp/showchase.dart';
import 'package:chaseapp/record.dart';
import 'package:chaseapp/topbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}
/*
Widget TopBar(BuildContext context) {
  return new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    // leading: new Icon(Icons.camera_alt),
    title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
    leading: new IconButton(
        icon: new Icon(Icons.face),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        // child: Icon(Icons.send),
      )
    ],
  );
}
*/

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

/*
  final topBar = new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    // leading: new Icon(Icons.camera_alt),
    title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
    leading: new IconButton(
        icon: new Icon(Icons.face),
        onPressed: () {
          Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage() ))
                }),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        // child: Icon(Icons.send),
      )
    ],
  );
  */

  void firebaseCloudMessaging_Listeners() {
    print('in fbCM_listeners');

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('ChaseApp.IO')),
      appBar: TopBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('chases').snapshots(),
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
            subtitle: Text(record.Votes.toString() + ' donuts'),
            trailing: new CircleAvatar(
                backgroundColor: Colors.pink,
                child: new Image(
                  image: new AssetImage("images/donut.jpg"),
                )),
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowChase(record: record)))
                }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
