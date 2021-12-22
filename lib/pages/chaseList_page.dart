import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:chaseapp/pages/chaseDetails_page.dart';
import 'package:chaseapp/helper/record.dart';
import 'package:chaseapp/pages/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class ChasesScreen extends StatefulWidget {
  const ChasesScreen({Key? key}) : super(key: key);

  @override
  _ChasesScreenState createState() => _ChasesScreenState();
}

class _ChasesScreenState extends State<ChasesScreen> {

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
   FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ChasesPage(title: 'Loading..', analytics: analytics, observer: observer));
  }
}

class ChasesPage extends StatefulWidget {
  const ChasesPage({Key? key, required this.title, required this.analytics, required this.observer})
    : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

   @override
    _ChasesPageState createState() => _ChasesPageState(analytics, observer);
}

class _ChasesPageState extends State<ChasesPage> {
  _ChasesPageState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  String _message = '';

 void setMessage(String message) {
   setState(() {
     _message = message;
   });
 }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: Column(
        children: <Widget>[
          TopBar(context)
        ],
      )
    ),
    body: _buildBody(context),
  );
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('chases')
        .orderBy('CreatedAt', descending: true)
        .snapshots(),
    builder: (context, AsyncSnapshot snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.docs);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data as DocumentSnapshot<Map<String, dynamic>>)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot<Map<String, dynamic>> data) {
  final record = Record.fromSnapshot(data);
  var imageURL = '';

  const String assetName = 'assets/donut2.svg';

  if (record.ImageURL != null) {
    imageURL = record.ImageURL.replaceAll(
        RegExp(r"\.([0-9a-z]+)(?:[?#]|$)",
          caseSensitive: false,
          multiLine: false,
        ), '_200x200.webp?');
  }

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
    // key: ValueKey(record.Name),
    key: ValueKey(record.ID),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
          leading: CircleAvatar(
            child: imageURL.isNotEmpty ? _displayImageURL(imageURL) : _displayPlaceholderIcon(),
          ),
          title: Text(record.Name, style: GoogleFonts.getFont('Poppins')),
          // subtitle: Text(record.Votes.toString() + ' donuts'),
          subtitle: Text(dateMsg),
          trailing: Chip(
            avatar: CircleAvatar(
              backgroundColor: Colors.black12,
              child: SvgPicture.asset(
                assetName
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
                    builder: (context) => ShowChase(record: record, key: UniqueKey(),)))
          }),
    ),
  );
}

}

_displayPlaceholderIcon() {
  return const Image(image: AssetImage("images/video.png"));
}

_displayImageURL(String imageURL) {
  return FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imageURL);
}

