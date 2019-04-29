import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:medium_clap_flutter/medium_clap_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChaseApp.IO',
      home: MyHomePage(),
    );
  }
}

class ShowChase extends StatelessWidget {
  final Record record;

  ShowChase({Key key, @required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Chase Details'),
        ),
        body: new SizedBox(
            height: 210,
            child: Card(
                child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(record.Name,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(record.Desc),
                  leading: Icon(Icons.access_alarm, color: Colors.blue[500]),
                  trailing: Text(record.Votes.toString() + ' donuts'),
                ),
                Divider(),
                Center(
                    // children: <Widget>[RaisedButton(child: Text(record.LiveURL))],
                    child: Linkify(onOpen: _onOpen, text: record.LiveURL)),
              ],
            ))));
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
      appBar: AppBar(title: Text('ChaseApp.IO')),
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
            leading: const Icon(Icons.video_library),
            title: Text(record.Name),
            subtitle: Text(record.Votes.toString() + ' donuts'),
            // trailing: ClapFAB.icon(
            trailing: ClapFAB.image(
              // clapFabCallback: (int counter) => print(counter),
              clapFabCallback: (int counter) =>
                  Firestore.instance.runTransaction((transaction) async {
                    final freshSnapshot =
                        await transaction.get(record.reference);
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
            /*
                    onPressed: () =>
                        Firestore.instance.runTransaction((transaction) async {
                          final freshSnapshot =
                              await transaction.get(record.reference);
                          final fresh = Record.fromSnapshot(freshSnapshot);
                          print('test');
                          await transaction.update(
                              record.reference, {'Votes': fresh.Votes + 1});
                        })),
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

  @override
  void initState() {
    super.initState();
    print('in initState');
    firebaseCloudMessaging_Listeners();
  }
} // _myHomePageState

class Record {
  final String Name;
  final String LiveURL;
  final String SavedURL;
  final Timestamp CreatedAt;
  final String Desc;
  final int Votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['CreatedAt'] != null),
        assert(map['LiveURL'] != null),
        // assert(map['SavedURL'] != null),
        assert(map['Votes'] != null),
        assert(map['Desc'] != null),
        Name = map['Name'],
        CreatedAt = map['CreatedAt'],
        LiveURL = map['LiveURL'],
        SavedURL = map['SavedURL'],
        Votes = map['Votes'],
        Desc = map['Desc'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$Name:$Votes>";
}
