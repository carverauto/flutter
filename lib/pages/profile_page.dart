import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/pages/authenticate_page.dart';
import 'package:chaseapp/pages/home_page.dart';
import 'package:chaseapp/services/auth_service.dart';
import 'package:chaseapp/pages/topbar.dart';
import 'package:flutter/services.dart';


class ProfilePage extends StatefulWidget{
  final String userName;
  final String email;

  const ProfilePage({Key key, this.userName, this.email}) : super(key: key);
  ProfPage createState() => ProfPage(userName: userName, email: email);
}

class ProfPage extends State<ProfilePage> {
  static const isScanning = const MethodChannel('com.carverauto.chaseap/nodle');
  String scanningMessage = 'Waiting..';
  String showConfigMessage = 'Waiting..';
  final String userName;
  final String email;
  // final AuthService _auth = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;

  ProfPage({this.userName, this.email});

  Future getNodleStatus() async {
    const platform = const MethodChannel('com.carverauto.chaseapp/nodle');
    String value;
    try {
      value = await platform.invokeMethod("isScanning");
    } catch (e) {
      print(e);
    }
    print(value);
    setState(() => scanningMessage = '$value');
  }

  Future getNodleConfig() async {
    const platform = const MethodChannel('com.carverauto.chaseapp/nodle');
    String value;
    try {
      value = await platform.invokeMethod("showConfig");
    } catch (e) {
      print(e);
    }
    print(value);
    setState(() => showConfigMessage = '$value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( title: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)), backgroundColor: Colors.black87, elevation: 0.0,),
      // appBar: TopBar(context), // #TODO: Replace or update this, we don't need to display the photoURL twice
      appBar: AppBar(
            // backgroundColor: new Color(0xfff8faf8),
            centerTitle: true,
            elevation: 1.0,
            // leading: new Icon(Icons.camera_alt),
            title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
            actions: <Widget>[
              Padding(
                 padding: const EdgeInsets.only(right: 12.0),
              // child: IconButton( icon: CircleAvatar( radius: 20, backgroundImage: CachedNetworkImageProvider(auth.currentUser.photoURL), ), onPressed: () => Navigator.push( context, MaterialPageRoute( builder: (context) => ProfilePage( userName: FirebaseAuth.instance.currentUser.displayName, email: FirebaseAuth.instance.currentUser.email, ) ) ) ),
              ),],

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Icon(Icons.account_circle, size: 200.0, color: Colors.grey[700]),
              CircleAvatar(
                radius: 75,
                backgroundImage: CachedNetworkImageProvider(FirebaseAuth.instance.currentUser.photoURL),
              ),
              SizedBox(height: 15.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(scanningMessage),
                    ElevatedButton(onPressed: getNodleStatus, child: Text('Nodle Scanning Status'))
                  ],
              ),
              Divider(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Full Name', style: TextStyle(fontSize: 17.0)),
                  Text(userName, style: TextStyle(fontSize: 17.0)),
                ],
              ),

              Divider(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Email', style: TextStyle(fontSize: 17.0)),
                  Text(email, style: TextStyle(fontSize: 17.0)),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}