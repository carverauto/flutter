import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/src/shared/util/helpers/helper_functions.dart';
import 'package:chaseapp/src/modules/auth/view/pages/authenticate_page.dart';
import 'package:chaseapp/src/modules/chats/view/pages/chat_page.dart';
import 'package:chaseapp/src/modules/profile/view/pages/profile_page.dart';
import 'package:chaseapp/src/modules/search/view/pages/search_page.dart';
import 'package:chaseapp/src/modules/auth/data/auth_service.dart';
import 'package:chaseapp/src/services/database_service.dart';
import 'package:chaseapp/src/shared/widgets/chase/chase_tile.dart';
// import 'package:chaseapp/helper/record.dart';
import 'package:chaseapp/src/modules/dashboard/view/pages/chaseList_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // data
  final AuthService _auth = AuthService();
  // final Record record;
  late User _user;
  String _userName = '';
  final String _email = '';
  Stream? _chases;

  // initState
  @override
  void initState() {
    super.initState();
  }

  /*
  Widget chasesList() {
    return StreamBuilder(
      stream: _chases,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // if(snapshot.data['chases'] != null) {
          if (snapshot.data != null) {
            // print(snapshot.data['groups'].length);
            if (snapshot.data['chases'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['chases'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['chases'].length - index - 1;
                    // return ChaseTile(userName: snapshot.data['Name'], chaseId: _destructureId(snapshot.data['chases'][reqIndex]), chaseName: _destructureName(snapshot.data['chases'][reqIndex]));
                    return ChaseTile(chaseName: snapshot.data['Name'],
                        chaseId: _destructureId(
                            snapshot.data['chases'][reqIndex]));
                  }
              );
            }
            else {
              return noChaseWidget();
            }
          }
          else {
            return noChaseWidget();
          }
        }
        else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }
*/
  // functions
  _getUserAuth() async {
    _user = FirebaseAuth.instance.currentUser!;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value!;
      });
    });

    /*
    //#TODO: this should be updated for chats, when we get to it - need to use google realtime db
    DatabaseService(uid: _user.uid).getChases().then((snapshots) { // #TODO: wtf is this
      // print(snapshots);
      setState(() {
        // _groups = snapshots;
        _chases = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
     */
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  /*
  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed:  () async {
        if(_chaseName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
        onChanged: (val) {
          _groupName = val;
        },
        style: TextStyle(
          fontSize: 15.0,
          height: 2.0,
          color: Colors.black             
        )
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  */

  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    //return ChasesScreen();
    return const Scaffold(
      body: ChasesScreen(),
    );
  }
}
