import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:chaseapp/pages/chat_page.dart';
import 'package:chaseapp/services/database_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // data
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  User _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  // initState()
  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUid();
  }


  // functions
  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    User _user = FirebaseAuth.instance.currentUser;
  }


  _initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

 
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        duration: Duration(milliseconds: 1500),
        content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
      )
    );
  }

/*
  _joinValueInGroup(String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }
 */


  // widgets
  Widget chaseList() {
    return hasUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.docs.length,
      itemBuilder: (context, index) {
        return chaseTile(
          _userName,
          searchResultSnapshot.docs[index].data()["chaseId"],
          searchResultSnapshot.docs[index].data()["chaseName"],
        );
      }
    )
    :
    Container();
  }


  Widget chaseTile(String userName, String chaseId, String chaseName) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.blueAccent,
        child: Text(chaseName.substring(0, 1).toUpperCase(), style: TextStyle(color: Colors.white))
      ),
      title: Text(chaseName, style: TextStyle(fontWeight: FontWeight.bold)),
      // subtitle: Text("Admin: $admin"),
      );
  }


  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black87,
        title: Text('Search', style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: // isLoading ? Container(
      //   child: Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // )
      // :
      Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search Chases...",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 16,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(Icons.search, color: Colors.white)
                    )
                  )
                ],
              ),
            ),
            isLoading ? Container(child: Center(child: CircularProgressIndicator())) : chaseList()
          ],
        ),
      ),
    );
  }
}
