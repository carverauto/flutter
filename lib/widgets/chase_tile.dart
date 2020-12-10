import 'package:flutter/material.dart';
import 'package:chaseapp/pages/chat_page.dart';

class ChaseTile extends StatelessWidget {
  final String userName;
  final String chaseId;
  final String chaseName;

  ChaseTile({this.userName, this.chaseId, this.chaseName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(chaseId: chaseId, userName: userName, chaseName: chaseName,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(chaseName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
          title: Text(chaseName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName", style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}