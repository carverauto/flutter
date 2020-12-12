import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/pages/authenticate_page.dart';
import 'package:chaseapp/pages/home_page.dart';
import 'package:chaseapp/services/auth_service.dart';
import 'package:chaseapp/pages/topbar.dart';

class ProfilePage extends StatelessWidget {

  final String userName;
  final String email;
  final AuthService _auth = AuthService();

  ProfilePage({this.userName, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( title: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)), backgroundColor: Colors.black87, elevation: 0.0,),
      appBar: TopBar(context),
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