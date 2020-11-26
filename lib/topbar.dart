import 'package:flutter/material.dart';
// import 'package:chaseapp/facebookOLD.dart';
import 'package:chaseapp/settings.dart';
// import 'package:chaseapp/login_page.dart';
import 'package:chaseapp/sign_in.dart';

Widget TopBar(BuildContext context) {
  return new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    // leading: new Icon(Icons.camera_alt),
    title: SizedBox(height: 35.0, child: Image.asset("images/chaseapp.png")),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child:
         CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.transparent
            // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()))
          ),
      ),
    ],
  );
}
