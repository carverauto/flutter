import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

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
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(record.name),
            subtitle: Text(record.votes.toString() + ' votes'),
            trailing:
                // child: Text(record.votes.toString()),
                IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () =>
                        Firestore.instance.runTransaction((transaction) async {
                          final freshSnapshot =
                              await transaction.get(record.reference);
                          final fresh = Record.fromSnapshot(freshSnapshot);
                          print('test');
                          await transaction.update(
                              record.reference, {'votes': fresh.votes + 1});
                        }))
            /*
          trailing: Text(record.votes.toString()),
          onTap: () => Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(record.reference);
                final fresh = Record.fromSnapshot(freshSnapshot);
                print('test');
                await transaction
                    .update(record.reference, {'votes': fresh.votes + 1});
              }),
              */
            ),
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
  final String name;
  final String liveUrl;
  final String savedUrl;
  final Timestamp createdAt;
  final String desc;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['createdAt'] != null),
        assert(map['liveUrl'] != null),
        assert(map['savedUrl'] != null),
        assert(map['votes'] != null),
        assert(map['desc'] != null),
        name = map['name'],
        createdAt = map['createdAt'],
        liveUrl = map['liveUrl'],
        savedUrl = map['savedUrl'],
        votes = map['votes'],
        desc = map['desc'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
