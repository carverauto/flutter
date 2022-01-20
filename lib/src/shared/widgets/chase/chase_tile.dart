import 'package:flutter/material.dart';
import 'package:chaseapp/src/modules/chats/view/pages/chat_page.dart';

class ChaseTile extends StatelessWidget {
  const ChaseTile(
      {Key? key,
      required this.userName,
      required this.chaseId,
      required this.chaseName,
      required this.uid})
      : super(key: key);
  final String userName;
  final String chaseId;
  final String chaseName;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    chaseId: chaseId,
                    userName: userName,
                    chaseName: chaseName,
                    uid: uid)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text(chaseName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
          ),
          title: Text(chaseName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName",
              style: const TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}
