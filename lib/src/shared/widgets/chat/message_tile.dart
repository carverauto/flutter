import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {

  const MessageTile({required this.message, required this.sender, required this.sentByMe});

  final String message;
  final String sender;
  final bool sentByMe;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0,),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
          borderRadius: sentByMe ? const BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23),
          )
          :
          const BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
          color: sentByMe ? Colors.blueAccent : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender.toUpperCase(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
            const SizedBox(height: 7),
            Text(message, textAlign: TextAlign.start, style: const TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}