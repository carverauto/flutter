import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class FireStoreRepository {
class FireStoreRepository extends StatefulWidget {
  FireStoreRepository(String chaseID, {Key key}) : _chaseID = chaseID, super(key: key);

  static String chaseID;
  final _chaseID;
  final CollectionReference _chatCollectionReference =
  // Firestore.instance.collection('Chat');
  FirebaseDatabase.instance.reference().child(chaseID).child("messages") as CollectionReference;


  final StreamController<List<ChatModel>> _chatController =
  StreamController<List<ChatModel>>.broadcast();

  List<List<ChatModel>> _allPagedResults = List<List<ChatModel>>();

  static const int chatLimit = 10;
  DocumentSnapshot _lastDocument;
  bool _hasMoreData = true;

  // FireStoreRepository(this.chaseID);

  Stream listenToChatsRealTime() {
    _requestChats();
    return _chatController.stream;
  }

  void _requestChats() {
    var pagechatQuery = _chatCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(chatLimit);

    if (_lastDocument != null) {
      pagechatQuery =
          pagechatQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;
    pagechatQuery.snapshots().listen(
          (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalChats = snapshot.docs
              .map((snapshot) => ChatModel.fromMap(snapshot.data()))
              .toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalChats;
          } else {
            _allPagedResults.add(generalChats);
          }

          var allChats = _allPagedResults.fold<List<ChatModel>>(
              List<ChatModel>(),
                  (initialValue, pageItems) => initialValue..addAll(pageItems));

          _chatController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalChats.length == chatLimit;
        }
      },
    );
  }

  void requestMoreData() => _requestChats();

  @override
  State<StatefulWidget> createState() => _ChatViewState(chaseID);

}

class ChatView extends StatefulWidget {
  ChatView(String chaseID, {Key key}) : _chaseID = chaseID, super(key: key);

  final _chaseID;

  print("CVChaseID: $_chaseID");

  @override
  _ChatViewState createState() => _ChatViewState(_chaseID);
}

class _ChatViewState extends State<ChatView> {

  List item = [];
  final chaseID;
  FireStoreRepository _fireStoreRepository;
  final ScrollController _listScrollController = new ScrollController();

  _ChatViewState(this.chaseID);

  @override
  void initState() {
    super.initState();
    print("ChaseID: ${this.chaseID}");
    _fireStoreRepository = FireStoreRepository(this.chaseID);
    _listScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flexible(
        child: StreamBuilder<List<ChatModel>>(
        stream: _fireStoreRepository.listenToChatsRealTime(),
    builder: (context, snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        controller: _listScrollController,
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (context, index) {
    return ListTile(
    title: Text(item[index]['message']),
    trailing: Text(DateFormat("hh:mm:ss").format(DateTime.fromMicrosecondsSinceEpoch(item[index]['timestamp'] * 1000)).toString()),
    );},);}),));
  }

  void _scrollListener() {
    if (_listScrollController.offset >=
        _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange) {
      _fireStoreRepository.requestMoreData();
    }
  }

}

class ChatModel {
  final String userID;
  final String message;
  final DateTime timeStamp;
  final String chaseID;

  ChatModel({this.userID, this.message, this.timeStamp, this.chaseID});

  //send
  Map<String, dynamic> toMap() {
    return {
      'userid': userID,
      'message': message,
      'timestamp': timeStamp,
    };
  }

  //fetch
  static ChatModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ChatModel(
      userID: map['userid'],
      message: map['message'],
      timeStamp: DateTime.fromMicrosecondsSinceEpoch(map['timestamp'] * 1000),
    );
  }
}
