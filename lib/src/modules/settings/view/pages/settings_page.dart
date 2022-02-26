// import 'package:chaseapp/utils/routeNames.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:chaseapp/utils/deviceSize.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

class SettingsView extends StatefulWidget {
  @override
  SettingsViewPage createState() => SettingsViewPage();
}

class SettingsViewPage extends State<SettingsView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void signOutGoogle() async {
    await _googleSignIn.signOut();
    print("User Sign Out");
  }

  bool _showSignIn = true;

  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsSettings()));
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Manage Notifications',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
