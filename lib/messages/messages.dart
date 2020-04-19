import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  StreamSubscription<QuerySnapshot> _subscription;

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Map<DocumentSnapshot, bool> _mapOfConnectedUserToAllMessagesReadStatus;

  String uid;

  @override
  void initState() {
    super.initState();
    _getMessages();
    _setUpSubscription();
    registerNotification();
    configLocalNotification();

    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        showNotification(message['notification']);
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        return;
      },
    );

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(uid)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'io.matherly.travel_world' : 'io.matherly.pna.play',
      'PNA',
      'Meeting Professionals',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, message['title'].toString(), message['body'].toString(),
            platformChannelSpecifics,
            payload: json.encode(message))
        .catchError((err) {
      print('NOTIFICATION SHOWING FAILED: $err');
    });

    print("NOTIFICATION SHOWING DONE");
  }

  final CollectionReference _collectionReference =
      Firestore.instance.collection("messages");

  Future<void> _getMessages() async {
    final FirebaseUser user = await firebaseAuth.currentUser();
    uid = user.uid;

    var snapshot = await _collectionReference
        .where('userIdList', arrayContains: uid)
        .orderBy('timestamp')
        .getDocuments();
    _mapOfConnectedUserToAllMessagesReadStatus = {};

    if (snapshot.documents.isNotEmpty) {
      for (var doc in snapshot.documents) {
        var areAllMessagesRead = (await doc.reference
                .collection('messageList')
                .getDocuments())
            .documents
            .every((document) =>
                (document.data['mapOfUidToReadStatus'] as Map)[uid] == true);
        _mapOfConnectedUserToAllMessagesReadStatus[doc] = areAllMessagesRead;
      }
    }

    setState(() {
      if (_mapOfConnectedUserToAllMessagesReadStatus.length > 1) {
        _mapOfConnectedUserToAllMessagesReadStatus = SplayTreeMap.from(
            _mapOfConnectedUserToAllMessagesReadStatus, (a, b) {
          if (a.data['timestamp'] == null || b.data['timestamp'] == null) {
            return 0;
          }
          var x = (b.data['timestamp'] as Timestamp)
              .compareTo(a.data['timestamp'] as Timestamp);
          return x;
        });
      }
    });
  }

  StreamSubscription<QuerySnapshot> _setUpSubscription() {
    return _subscription = _collectionReference.snapshots().listen(
      (datasnapshot) {
        setState(() {
          _getMessages();
        });
      },
    );
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAppBar(),
          _buildSearchBar(),
          Expanded(
            child: _mapOfConnectedUserToAllMessagesReadStatus != null
                ? _mapOfConnectedUserToAllMessagesReadStatus.isEmpty
                    ? Container()
                    : Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          child: ListView.builder(
                            itemCount:
                                _mapOfConnectedUserToAllMessagesReadStatus
                                    .length,
                            itemBuilder: ((context, index) {
                              return _buildChatListTile(index, context);
                            }),
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            title: Text(''),
            icon: IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Navigation()),
                );
              },
            ),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.vpn_lock,
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Meetup()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Color(0xffc67608),
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
              onPressed: () {},
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.perm_identity,
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Chats'.toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      centerTitle: true,
    );
  }

  Column _buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          width: 330,
          height: 50,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          ),
        ),
      ],
    );
  }

  ListTile _buildChatListTile(int index, BuildContext context) {
    String otherUserId = ((_mapOfConnectedUserToAllMessagesReadStatus.keys
            .elementAt(index)
            .data['userIdList'] as List)
        .singleWhere((uidFromList) => uidFromList != uid, orElse: () => uid));

    String otherName = (_mapOfConnectedUserToAllMessagesReadStatus.keys
        .elementAt(index)
        .data['mapOfUidToUsername'] as Map)[otherUserId];
    String otherPhotoUrl = (_mapOfConnectedUserToAllMessagesReadStatus.keys
        .elementAt(index)
        .data['mapOfUidToPhotoUrl'] as Map)[otherUserId];
    String otherCountry = (_mapOfConnectedUserToAllMessagesReadStatus.keys
        .elementAt(index)
        .data['mapOfUidToCountry'] as Map)[otherUserId];

    bool areAllMessagesRead =
        _mapOfConnectedUserToAllMessagesReadStatus.values.elementAt(index);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: new BoxDecoration(
          color: Color(0xffc67608), // border color
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(otherPhotoUrl),
        ),
      ),
      title: Text(otherName,
          style: TextStyle(
            color: Colors.white,
          )),
      subtitle: Text(otherCountry == null ? '' : otherCountry,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 17,
          )),
      trailing: areAllMessagesRead
          ? SizedBox.shrink()
          : CircleAvatar(backgroundColor: Color(0xffc67608), radius: 8.0),
      onTap: (() {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => ChatScreen(
                      name: otherName,
                      photoUrl: otherPhotoUrl,
                      receiverUid: otherUserId,
                      country: otherCountry,
                    ))).whenComplete(() {
          setState(() {
            if (areAllMessagesRead == false) areAllMessagesRead = true;
          });
          _getMessages(); //Refresh screen
        });
      }),
    );
  }
}
