import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medium_clap_flutter/medium_clap_flutter.dart';
import 'package:share/share.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          height: 250,
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final topBar = new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    // leading: new Icon(Icons.camera_alt),
    title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        // child: Icon(Icons.send),
      )
    ],
  );

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
      appBar: topBar,
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

class Record {
  final String Name;
  final String LiveURL;
  final String SavedURL;
  final bool Live;
  final Timestamp CreatedAt;
  final String Desc;
  final int Votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['CreatedAt'] != null),
        assert(map['LiveURL'] != null),
        assert(map['Live'] != null),
        // assert(map['SavedURL'] != null),
        assert(map['Votes'] != null),
        assert(map['Desc'] != null),
        Name = map['Name'],
        CreatedAt = map['CreatedAt'],
        LiveURL = map['LiveURL'],
        Live = map['Live'],
        SavedURL = map['SavedURL'],
        Votes = map['Votes'],
        Desc = map['Desc'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$Name:$Votes>";
}
