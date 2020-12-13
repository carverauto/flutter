import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference chaseCollection = FirebaseFirestore.instance.collection('chases');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'profilePic': ''
    });
  }
  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  getChases() async {
    return FirebaseFirestore.instance.collection("chases").snapshots();
  }

  // send message
  sendMessage(String chaseId, chatMessageData) {
    FirebaseFirestore.instance.collection('chases').doc(chaseId).collection('messages').add(chatMessageData);
    FirebaseFirestore.instance.collection('chases').doc(chaseId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  // get chats of a particular chase
  getChats(String chaseId) async {
    return FirebaseFirestore.instance.collection('chases').doc(chaseId).collection('messages').orderBy('time').snapshots();
  }

  // search chase
  searchByName(String chaseName) {
    return FirebaseFirestore.instance.collection("chases").where('chaseName', isEqualTo: chaseName).get();
  }
}