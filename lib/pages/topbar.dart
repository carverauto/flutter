import 'package:chaseapp/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/pages/settings_page.dart';
import 'package:chaseapp/services/auth_service.dart';
import 'package:chaseapp/pages/authenticate_page.dart';
import 'package:flutter/services.dart';
import 'authenticate_page.dart';

Widget TopBar(BuildContext context) {

  FirebaseAuth auth = FirebaseAuth.instance;

  var defaultPhotoURL = 'https://chaseapp.tv/icon.png';

  return AppBar(
      // backgroundColor: new Color(0xfff8faf8),
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
                  backgroundImage: CachedNetworkImageProvider(auth.currentUser?.photoURL ?? defaultPhotoURL),
                ),
                onPressed: () => Navigator.push(
                    // context, MaterialPageRoute(builder: (context) => Settings()))),
                  context,
                    MaterialPageRoute(builder: (context) =>
                        ProfilePage(
                          userName: FirebaseAuth.instance.currentUser?.displayName ?? 'John Doe',
                          email: FirebaseAuth.instance.currentUser?.email ?? 'your@email.com',
                        )
                    )
                )
            ),
        ),
      ],
    );
  }
