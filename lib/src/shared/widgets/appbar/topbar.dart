import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/modules/profile/view/pages/profile_page.dart';
import 'package:chaseapp/src/top_level_providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBar extends ConsumerWidget {
  const TopBar({Key? key}) : super(key: key);
  final defaultPhotoURL = 'https://chaseapp.tv/icon.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                backgroundImage: CachedNetworkImageProvider(
                    ref.read(firebaseAuthProvider).currentUser?.photoURL ??
                        defaultPhotoURL),
              ),
              onPressed: () => Navigator.push(
                  // context, MaterialPageRoute(builder: (context) => Settings()))),
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            userName: FirebaseAuth
                                    .instance.currentUser?.displayName ??
                                'John Doe',
                            email: FirebaseAuth.instance.currentUser?.email ??
                                'your@email.com',
                            key: UniqueKey(),
                          )))),
        ),
        ElevatedButton(
            onPressed: () {
              ref.read(authRepoProvider).signOut();
            },
            child: Text('Logout'))
      ],
    );
  }
}
