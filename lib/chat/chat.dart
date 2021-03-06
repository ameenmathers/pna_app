import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:travel_world/full_screen_image.dart';
import 'package:travel_world/models/message.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String photoUrl;
  final String receiverUid;
  final String country;
  ChatScreen({
    @required this.name,
    @required this.photoUrl,
    @required this.receiverUid,
    @required this.country,
  });

  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Message _message;

  var _formKey = GlobalKey<FormState>();
  var map = Map<String, dynamic>();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _senderUid;
  var listItem;
  String receiverPhotoUrl,
      senderPhotoUrl,
      receiverName,
      senderName,
      senderCountry;

  Stream<QuerySnapshot> snapshotStream;

  StreamSubscription<QuerySnapshot> subscription;

  File imageFile;
  StorageReference _storageReference;
  TextEditingController _messageController;


  List<DocumentSnapshot> _chatMessagesDocuments = List();
  bool _loadingChatMessages = true;

  @override
  void initState() {
    super.initState();
//    registerNotification();
    _messageController = TextEditingController();

    getUID().then((user) {
      setState(() {
        _senderUid = user.uid;
      });
      snapshotStream = Firestore.instance
          .collection('messages')
          .document(_getDocumentId(_senderUid, widget.receiverUid))
          .collection('messageList')
          .orderBy('timestamp', descending: false)
          .snapshots();

      subscription = snapshotStream.listen((event) {
        var documents = event.documents;

        if (documents != null) {
          setState(() {
            _chatMessagesDocuments.clear();
            _chatMessagesDocuments.addAll(event.documents);
            _chatMessagesDocuments = _chatMessagesDocuments.reversed.toList()
                as List<DocumentSnapshot>;
            _loadingChatMessages = false;
            _setAsRead(event);
          });
        } else {
          _loadingChatMessages = false;
        }
      });

      print("sender uid : $_senderUid");
      getSenderPhotoUrl(_senderUid).then((snapshot) {
        setState(() {
          senderPhotoUrl = snapshot['photoUrl'];
          senderName = snapshot['name'];
          senderCountry = snapshot['country'];
        });
      });
      getReceiverPhotoUrl(widget.receiverUid).then((snapshot) {
        setState(() {
          receiverPhotoUrl = snapshot['photoUrl'];
          receiverName = snapshot['name'];
        });
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();

    super.dispose();
  }

  String _getDocumentId(String senderUid, String receiverUid) {
    String _documentId;
    if (senderUid.compareTo(receiverUid).isNegative) {
      _documentId = senderUid + receiverUid;
    } else {
      _documentId = receiverUid + senderUid;
    }

    return _documentId;
  }

  Future<void> addMessageToDb(Message message) async {
    String documentPath = _getDocumentId(_senderUid, widget.receiverUid);

    print("Message : ${message.message}");
    map = message.toMap();

    print("Map : $map");

    DocumentReference documentReference = _getDocumentReference(
      collectionPath: 'messages',
      documentPath: documentPath,
    );

    var batch = Firestore.instance.batch();

    batch.setData(
        documentReference,
        {
          'mapOfUidToUsername': {
            _senderUid: senderName,
            widget.receiverUid: widget.name
          },
          'mapOfUidToPhotoUrl': {
            _senderUid: senderPhotoUrl,
            widget.receiverUid: widget.photoUrl,
          },
          'mapOfUidToCountry': {
            _senderUid: senderCountry,
            widget.receiverUid: widget.country
          },
          'userIdList': [_senderUid, widget.receiverUid],
          'timestamp': FieldValue.serverTimestamp(),
        },
        merge: true);

    CollectionReference collectionReference =
        documentReference.collection('messageList');

    batch.setData(collectionReference.document(), map);

    await batch.commit();

    print("Messages added to db");

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
          child: _senderUid == null
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
                    _buildChatInputWidget(),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
        ));
  }

  Widget _buildChatInputWidget() {
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 55.0,
            color: Colors.black,
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
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              validator: (String input) {
                if (input.isEmpty) {
                  return "Please enter message";
                }

                return null;
              },
              controller: _messageController,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  hintText: "Enter message...",
                  labelText: "Message",
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.black,
                  filled: true,
                  focusColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffc67608)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffc67608)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Color(0xffc67608)),
                  )),
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

  DocumentReference _getDocumentReference({
    @required String collectionPath,
    @required String documentPath,
  }) {
    final CollectionReference collectionReference =
        Firestore.instance.collection(collectionPath);

    final DocumentReference documentReference =
        collectionReference.document(documentPath);

    return documentReference;
  }

  Future<void> uploadImageToDb(String downloadUrl) async {
    _message = Message.withoutMessage(
        receiverUid: widget.receiverUid,
        senderUid: _senderUid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : $map");

    String documentPath = _getDocumentId(_senderUid, widget.receiverUid);

    DocumentReference documentReference = _getDocumentReference(
      collectionPath: 'messages',
      documentPath: documentPath,
    );

    documentReference.setData({});

    CollectionReference collectionReference =
        documentReference.collection('messageList');

    await collectionReference.add(map);
    print("Messages added to db");
  }

  void sendMessage() async {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderUid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text',
        mapOfUidToReadStatus: {
          widget.receiverUid: false,
          _senderUid: true,
        });
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : $_senderUid , message: $text");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    await addMessageToDb(_message);
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

  _setAsRead(QuerySnapshot snapshot) async {
    String documentPath = _getDocumentId(_senderUid, widget.receiverUid);
    DocumentReference documentReference = _getDocumentReference(
      collectionPath: 'messages',
      documentPath: documentPath,
    );

    CollectionReference collectionReference =
        documentReference.collection('messageList');

    var batch = Firestore.instance.batch();

    for (var doc in snapshot.documents) {
      print('loop');
      batch.updateData(
        collectionReference.document(doc.documentID),
        {'mapOfUidToReadStatus.$_senderUid': true},
      );
    }

    print('after loop');

    try {
      await batch.commit();
      print('done');
    } catch (e) {
      print(e);
    }
  }

  QuerySnapshot cache;

  Widget ChatMessagesListWidget() {
    print("SENDERUID : $_senderUid");
    return Expanded(
      child: _loadingChatMessages
          ? Container(child: Center(child: CircularProgressIndicator()))
          : ListView.builder(
              itemCount: _chatMessagesDocuments.length,
              reverse: true,
              itemBuilder: (context, index) {
                var document = _chatMessagesDocuments[index];
                return chatMessageItem(document);
              },
            ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
    return buildChatLayout(documentSnapshot);
  }

  Widget buildChatLayout(DocumentSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: snapshot['senderUid'] == _senderUid
              ? Wrap(
                  textDirection: TextDirection.rtl,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            snapshot['timestamp'] == null
                                ? new Container()
                                : Text(
                                    timeago
                                        .format(snapshot['timestamp'].toDate()),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13.0),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        snapshot['type'] == 'text'
                            ? new Material(
                                elevation: 10.0,
                                color: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                    color: Colors.white12,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    snapshot['message'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13.0),
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
                                  color: Colors.black54,
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Hero(
                                      tag: snapshot['photoUrl'],
                                      child: FadeInImage(
                                        image:
                                            NetworkImage(snapshot['photoUrl']),
                                        placeholder: AssetImage(''),
                                        width: 200.0,
                                        height: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    snapshot['senderUid'] == _senderUid
                        ? Icon(
                            MaterialCommunityIcons.check_all,
                            color: Colors.white,
                            size: 14.0,
                          )
                        : SizedBox.shrink()
                  ],
                )
              : Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            snapshot['timestamp'] == null
                                ? new Container()
                                : Text(
                                    timeago
                                        .format(snapshot['timestamp'].toDate()),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13.0),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                        color: Colors.white, fontSize: 13.0),
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
                                        image:
                                            NetworkImage(snapshot['photoUrl']),
                                        placeholder: AssetImage(''),
                                        width: 200.0,
                                        height: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    snapshot['senderUid'] == _senderUid
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
