import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:chaseapp/pages/authenticate_page.dart';
import 'package:chaseapp/pages/chat_page.dart';
import 'package:chaseapp/pages/profile_page.dart';
import 'package:chaseapp/pages/search_page.dart';
import 'package:chaseapp/services/auth_service.dart';
import 'package:chaseapp/services/database_service.dart';
import 'package:chaseapp/widgets/chase_tile.dart';
// import 'package:chaseapp/helper/record.dart';
import 'package:chaseapp/pages/chaseList_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // data
  final AuthService _auth = AuthService();
  // final Record record;
  User _user;
  String _userName = '';
  String _email = '';
  Stream _chases;


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
    _user = FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getChases().then((snapshots) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Chases', style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black87,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            icon: Icon(Icons.search, color: Colors.white, size: 25.0), 
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
            }
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(_userName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(userName: _userName, email: _email)));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      body: ChasesScreen(),
    );
  }
}
