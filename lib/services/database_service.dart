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


  /*
  // create group
  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName]),
        'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });
  }
   */


  // toggling the user group join
  /*
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> chases = await userDocSnapshot.data['chases'];

    if(groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    }
    else {
      //print('nay');
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }


  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    
    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }

  */
  // get user data
  Future getUserData(String email) async {
    //QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).getDocuments();
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }


  // get user groups

//  getUserGroups() async {
  getChases() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
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


  // get chats of a particular group
  getChats(String chaseId) async {
    return FirebaseFirestore.instance.collection('chases').doc(chaseId).collection('messages').orderBy('time').snapshots();
  }


  // search groups
  searchByName(String chaseName) {
    return FirebaseFirestore.instance.collection("chases").where('chaseName', isEqualTo: chaseName).get();
  }
}