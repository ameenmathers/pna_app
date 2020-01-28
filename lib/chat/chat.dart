import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_world/full_screen_image.dart';
import 'package:travel_world/models/message.dart';

class ChatScreen extends StatefulWidget {
  String name;
  String photoUrl;
  String receiverUid;
  ChatScreen({this.name, this.photoUrl, this.receiverUid});

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Message _message;
  final _auth = FirebaseAuth.instance;

  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();

  CollectionReference _collectionReference;
  DocumentReference _receiverDocumentReference;
  DocumentReference _senderDocumentReference;
  DocumentReference _documentReference;
  DocumentSnapshot documentSnapshot;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderuid;
  var listItem;
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;
  StorageReference _storageReference;
  TextEditingController _messageController;

//  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

//  void registerNotification() async {
//    firebaseMessaging.requestNotificationPermissions();
//
//    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
//      print('onMessage: $message');
//      showNotification(message['notification']);
//      return;
//    }, onResume: (Map<String, dynamic> message) {
//      print('onResume: $message');
//      return;
//    }, onLaunch: (Map<String, dynamic> message) {
//      print('onLaunch: $message');
//      return;
//    });
//
//    final FirebaseUser user = await _auth.currentUser();
//    final uid = user.uid;
//
//    firebaseMessaging.getToken().then((token) {
//      print('token: $token');
//      Firestore.instance
//          .collection('users')
//          .document(uid)
//          .updateData({'pushToken': token});
//    }).catchError((err) {
//      Fluttertoast.showToast(msg: err.message.toString());
//    });
//  }

  @override
  void initState() {
    super.initState();
//    registerNotification();
    _messageController = TextEditingController();
    getUID().then((user) {
      setState(() {
        _senderuid = user.uid;
        print("sender uid : $_senderuid");
        getSenderPhotoUrl(_senderuid).then((snapshot) {
          setState(() {
            senderPhotoUrl = snapshot['photoUrl'];
            senderName = snapshot['name'];
          });
        });
        getReceiverPhotoUrl(widget.receiverUid).then((snapshot) {
          setState(() {
            receiverPhotoUrl = snapshot['photoUrl'];
            receiverName = snapshot['name'];
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void addMessageToDb(Message message) async {
    print("Message : ${message.message}");
    map = message.toMap();

    print("Map : ${map}");
    _collectionReference = await _getCollectionReference(
        firstCollectionPath: 'messages',
        documentPath: message.senderUid,
        secondCollectionPath: widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = await _getCollectionReference(
        firstCollectionPath: 'messages',
        documentPath: widget.receiverUid,
        secondCollectionPath: message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Form(
          key: _formKey,
          child: _senderuid == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    //buildListLayout(),
                    ChatMessagesListWidget(),
                    Divider(
                      height: 20.0,
                      color: Colors.white,
                    ),
                    ChatInputWidget(),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
        ));
  }

  Widget ChatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.black,
              icon: Icon(
                Icons.camera_alt,
                color: Color(0xffc67608),
              ),
              onPressed: () {
                pickImage();
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              validator: (String input) {
                if (input.isEmpty) {
                  return "Please enter message";
                }
              },
              controller: _messageController,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  hintText: "Enter message...",
                  labelText: "Message",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  fillColor: Colors.black,
                  filled: true,
                  focusColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffc67608)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0))),
              onFieldSubmitted: (value) {
                _messageController.text = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              splashColor: Colors.black,
              icon: Icon(
                Icons.send,
                color: Color(0xffc67608),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  sendMessage();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> pickImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = selectedImage;
    });
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");
    uploadImageToDb(url);
    return url;
  }

  Future<CollectionReference> _getCollectionReference(
      {@required String firstCollectionPath,
      @required String documentPath,
      @required String secondCollectionPath}) async {
    final CollectionReference collectionReference =
        Firestore.instance.collection(firstCollectionPath);

    final DocumentReference documentReference =
        collectionReference.document(documentPath);

    await documentReference.setData({}); //This creates the document

    final CollectionReference finalCollectionReference =
        documentReference.collection(secondCollectionPath);

    return finalCollectionReference;
  }

  Future<void> uploadImageToDb(String downloadUrl) async {
    _message = Message.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : ${map}");
    _collectionReference = await _getCollectionReference(
        firstCollectionPath: 'messages',
        documentPath: _message.senderUid,
        secondCollectionPath: widget.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });

    _collectionReference = await _getCollectionReference(
        firstCollectionPath: 'messages',
        documentPath: widget.receiverUid,
        secondCollectionPath: _message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });
  }

  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , message: ${text}");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    addMessageToDb(_message);
  }

  Future<FirebaseUser> getUID() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<DocumentSnapshot> getSenderPhotoUrl(String uid) {
    var senderDocumentSnapshot =
        Firestore.instance.collection('users').document(uid).get();
    return senderDocumentSnapshot;
  }

  Future<DocumentSnapshot> getReceiverPhotoUrl(String uid) {
    var receiverDocumentSnapshot =
        Firestore.instance.collection('users').document(uid).get();
    return receiverDocumentSnapshot;
  }

  Widget ChatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_senderuid)
            .collection(widget.receiverUid)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            listItem = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    return buildChatLayout(documentSnapshot);
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  snapshot['type'] == 'text'
                      ? new Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white12,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              snapshot['message'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: (() {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                          imageUrl: snapshot['photoUrl'],
                                        )));
                          }),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white12,
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Hero(
                                tag: snapshot['photoUrl'],
                                child: FadeInImage(
                                  image: NetworkImage(snapshot['photoUrl']),
                                  placeholder: AssetImage(''),
                                  width: 200.0,
                                  height: 200.0,
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
              snapshot['senderUid'] == _senderuid
                  ? Icon(
                      MaterialCommunityIcons.check_all,
                      color: Colors.white,
                      size: 14.0,
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ],
    );
  }
}
