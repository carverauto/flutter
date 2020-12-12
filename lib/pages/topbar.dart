import 'package:chaseapp/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/pages/settings_page.dart';
import 'package:chaseapp/services/auth_service.dart';
import 'package:chaseapp/pages/authenticate_page.dart';
import 'authenticate_page.dart';

Widget TopBar(BuildContext context) {

  FirebaseAuth auth = FirebaseAuth.instance;
  /*
  final AuthService _auth = AuthService();
  // final Record record;
  User _user;

  _user = FirebaseAuth.instance.currentUser;
  assert(_user != null);
   */

  //assert(auth.currentUser != null);

  return new AppBar(
      backgroundColor: new Color(0xfff8faf8),
      centerTitle: true,
      elevation: 1.0,
      // leading: new Icon(Icons.camera_alt),
      title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
                icon: CircleAvatar(
                  radius: 20,
                  // backgroundImage: NetworkImage(imageUrl),
                  // backgroundImage: CachedNetworkImage( placeholder: (context, url) => CircularProgressIndicator(), imageUrl: imageUrl),
                  backgroundImage: CachedNetworkImageProvider(auth.currentUser.photoURL),
                ),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Settings()))),
            // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()))
            ),
       /* Scaffold(
         drawer: Drawer(
           child: ListView(
             padding: EdgeInsets.symmetric(vertical: 50.0),
             children: <Widget>[
               Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
               SizedBox(height: 15.0),
               Text(auth.currentUser.displayName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
               SizedBox(height: 7.0),
               ListTile(
                 onTap: () {},
                 selected: true,
                 contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                 leading: Icon(Icons.group),
                 title: Text('Chases'),
               ),
               ListTile(
                 onTap: () {
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(userName: auth.currentUser.displayName, email: auth.currentUser.email)));
                 },
                 contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                 leading: Icon(Icons.account_circle),
                 title: Text('Profile'),
               ),
               ListTile(
                 onTap: () async {
                   await auth.signOut();
                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
                 },
                 contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                 leading: Icon(Icons.exit_to_app, color: Colors.red),
                 title: Text('Log Out', style: TextStyle(color: Colors.red)),
               ),
             ],
           ),
         ),
       ) */
      ],
    );
  }
