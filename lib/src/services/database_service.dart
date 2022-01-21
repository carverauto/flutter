// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

// //TODO: Break down into smaller services according to use in different modules
// class DatabaseService {
//   final String uid;
//   DatabaseService({required this.uid});

//   // send message
//   sendMessage(String chaseId, chatMessageData) {
//     FirebaseFirestore.instance
//         .collection('chases')
//         .doc(chaseId)
//         .collection('messages')
//         .add(chatMessageData);
//     FirebaseFirestore.instance.collection('chases').doc(chaseId).update({
//       'recentMessage': chatMessageData['message'],
//       'recentMessageSender': chatMessageData['sender'],
//       'recentMessageTime': chatMessageData['time'].toString(),
//     });
//   }

//   // get chats of a particular chase
//   getChats(String chaseId) async {
//     return FirebaseFirestore.instance
//         .collection('chases')
//         .doc(chaseId)
//         .collection('messages')
//         .orderBy('time')
//         .snapshots();
//   }

//   // search chase
//   searchByName(String chaseName) {
//     return FirebaseFirestore.instance
//         .collection("chases")
//         .where('chaseName', isEqualTo: chaseName)
//         .get();
//   }
// }
