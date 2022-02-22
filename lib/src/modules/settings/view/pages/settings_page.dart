// import 'package:chaseapp/utils/routeNames.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pusher_beams/pusher_beams.dart';
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

class NotificationsSettings extends StatelessWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Live chase notifications',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            trailing: Switch.adaptive(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.fire_extinguisher_outlined,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Firehose notifications',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            trailing: FirehoseNotification(),
          ),
        ],
      ),
    );
  }
}

class FirehoseNotification extends StatefulWidget {
  const FirehoseNotification({
    Key? key,
  }) : super(key: key);

  @override
  State<FirehoseNotification> createState() => _FirehoseNotificationState();
}

class _FirehoseNotificationState extends State<FirehoseNotification> {
  bool isAdded = true;

  Future<void> checkForInterests() async {
    final userInterests = await PusherBeams.instance.getDeviceInterests();

    final isAdded = userInterests.contains('firehose-notfiications');

    setState(() {
      this.isAdded = isAdded;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: isAdded,
      onChanged: (value) async {
        // if (value) {
        //   await PusherBeams.instance
        //       .addDeviceInterest("firehose-notfiications");
        // } else {
        //   await PusherBeams.instance
        //       .removeDeviceInterest("firehose-notfiications");
        // }
      },
    );
  }
}
