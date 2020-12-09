import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/model/chat_message.dart';
import 'package:chaseapp/service/authentication.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(String chaseId, {Key key, this.auth, this.userId, this.onSignedOut})
      : _chaseId = chaseId,
        super(key: key);

  final _chaseId;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State createState() => ChatScreenState(_chaseId);
}

// const List<Choice> choices = const <Choice>[const Choice('Sign out'), const Choice('Settings')];

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _chaseId;
  final List<ChatMessage> _messages;
  final TextEditingController _textController;
  final DatabaseReference _messageDatabaseReference;
  // final Reference _photoStorageReference;

  bool _isComposing = false;

  int timestamp;


  ChatScreenState(String chaseId)
      : _chaseId = chaseId,
        _isComposing = false,
        _messages = <ChatMessage>[],
        _textController = TextEditingController(),
        _messageDatabaseReference = FirebaseDatabase.instance.reference().child(chaseId).child("messages") {
    // _messageDatabaseReference.limitToLast(2).onChildAdded.listen(_onMessageAdded);
    _messageDatabaseReference.onChildAdded.listen(_onMessageAdded);

    print (">> Message count: ");
    print ( _messages.length );
  }

/*
  ChatScreenState(String title) : _title = title,
        _isComposing = false,
        _messages = <ChatMessage>[],
        _textController = TextEditingController()
         _messageDatabaseReference = FirebaseDatabase.instance.reference().child("messages"),
        _photoStorageReference = FirebaseStorage.instance.ref().child("chat_photos") 
        {
    _messageDatabaseReference.onChildAdded.listen(_onMessageAdded);
  }
  */

  Widget _buildTextComposer() {

    return SafeArea(
        // data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
      //child: SizedBox(
      // width: 200.0,
      // height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: <Widget>[
                  /*
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _sendImageFromCamera,
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _sendImageFromGallery,
                      ),
                      */
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Send"),
                          onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
                        )
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
                        ),
                ],
              ))
        ],
      ),
    ));
  }

  void _onMessageAdded(Event event) {
    // final _list = List<Event>();
    // final _listController = StreamController<List<Event>>.broadcast();

    final text = event.snapshot.value["text"];
    final imageUrl = event.snapshot.value["imageUrl"];
    final name = event.snapshot.value["username"];
    timestamp = event.snapshot.value["timestamp"];

    // final Timestamp = FirebaseDatabase
    // var serverTimestamp = FieldValue.serverTimestamp();
    // final timestamp = serverTimestamp;

    ChatMessage message;
    if (imageUrl == null) {
      message = _createMessageFromText(text, name, timestamp);
    } else {
      message = _createMessageFromImage(imageUrl);
    }

    if (mounted) {
      setState(() {
        _messages.insert(0, message);
      });
    }

    // _list.addAll(_messages.toList());
    // _listController.sink.add(_list);

    message.animationController.forward();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    final ChatMessage message = _createMessageFromText(text, FirebaseAuth.instance.currentUser.displayName, timestamp);
    // _messageDatabaseReference.push().set(message.toMap());
    // _messageDatabaseReference.push().set({"message": message.toMap(), "timestamp": DateTime.now().millisecondsSinceEpoch});
    message.timestamp = DateTime.now().millisecondsSinceEpoch;
    _messageDatabaseReference.push().set(message.toMap());
  }

/*
  void _sendImage(ImageSource imageSource) async {
    File image = await ImagePicker.pickImage(source: imageSource);
    final String fileName = Uuid().v4();
    Reference photoRef = _photoStorageReference.child(fileName);
    final StorageUploadTask uploadTask = photoRef.putFile(image);
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final ChatMessage message = _createMessageFromImage(
      await downloadUrl.ref.getDownloadURL(),
    );
    _messageDatabaseReference.push().set(message.toMap());
  }

  void _sendImageFromCamera() async {
    _sendImage(ImageSource.camera);
  }

  void _sendImageFromGallery() async {
    _sendImage(ImageSource.gallery);
  }
  */

  ChatMessage _createMessageFromText(String text, String name, int timestamp) => ChatMessage(
        text: text,
        // username: _name,
        // username: FirebaseAuth.instance.currentUser.displayName,
        username: name,
        timestamp: timestamp,
        animationController: AnimationController(
          duration: Duration(milliseconds: 180),
          vsync: this,
        ),
      );

  ChatMessage _createMessageFromImage(String imageUrl) => ChatMessage(
        imageUrl: imageUrl,
        username: 'foo',
        animationController: AnimationController(
          duration: Duration(milliseconds: 90),
          vsync: this,
        ),
      );

  @override
  Widget build(BuildContext context) {

    String title = 'test';
    String prevTitle = '';

    ScrollController _controller;

    @override
    void initState() {
      _controller = ScrollController();
      super.initState();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
        setState(() {
          title = "reached bottom";
        });
      } else if (_controller.offset <= _controller.position.minScrollExtent && !_controller.position.outOfRange) {
        setState(() {
          title = "reached top";
        });
      } else {
        setState(() {
          title = prevTitle;
        });
      }
    });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                controller: _controller,
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                top: BorderSide(color: Colors.grey[200]),
              ))
            : null,
      ),
    );

    /*
    _scrollListener() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {
          message = "reach the bottom";
        });
      }
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {jj
          message = "reach the top";
        });
      }
    }
     */
  }


  @override
  void dispose() {
    for (ChatMessage message in _messages) message.animationController.dispose();
    super.dispose();
  }

  /*
  void _select(Choice choice) {
    switch (choice.title) {
      case 'Sign out':
        _signOut();
        break;
    }
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  */
}

class Choice {
  const Choice(this.title);

  final String title;
}
