import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chaseCollection =
      FirebaseFirestore.instance.collection('chases');

  // update userdata
  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "uid": uid,
      'userName': fullName,
      'email': email,
      // 'password': password,
      'photoUrl': null,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch
    });
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    if (kDebugMode) {
      print(snapshot.docs[0].data);
    }
    return snapshot;
  }

  getChases() async {
    return FirebaseFirestore.instance.collection("chases").snapshots();
  }

  // send message
  sendMessage(String chaseId, chatMessageData) {
    FirebaseFirestore.instance
        .collection('chases')
        .doc(chaseId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('chases').doc(chaseId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular chase
  getChats(String chaseId) async {
    return FirebaseFirestore.instance
        .collection('chases')
        .doc(chaseId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // search chase
  searchByName(String chaseName) {
    return FirebaseFirestore.instance
        .collection("chases")
        .where('chaseName', isEqualTo: chaseName)
        .get();
  }
}
