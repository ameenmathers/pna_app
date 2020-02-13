import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Map<DocumentSnapshot, bool> _mapOfConnectedUserToAllMessagesReadStatus = {};

  String uid;

  @override
  void initState() {
    super.initState();
    _setUpSubscription();

    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  bool _isLoading;

  final CollectionReference _collectionReference =
      Firestore.instance.collection("messages");

  Future<QuerySnapshot> messagesSnapshot;

  Future<void> _getMessages() async {
    setState(() {
      _isLoading = true;
    });

    final FirebaseUser user = await firebaseAuth.currentUser();
    uid = user.uid;

    var connectivityResult = await (Connectivity().checkConnectivity());

    Source source;

    if (connectivityResult == ConnectivityResult.none) {
      print('no internet');
      try {
        print('use cache');

        setState(() {
          source = Source.cache;
          messagesSnapshot = _collectionReference
              .where('userIdList', arrayContains: uid)
              .orderBy('timestamp')
              .getDocuments(source: source);
        });
      } catch (e) {
        print('use server');

        setState(() {
          source = Source.serverAndCache;

          messagesSnapshot = _collectionReference
              .where('userIdList', arrayContains: uid)
              .orderBy('timestamp')
              .getDocuments(source: source);
        });
      }
    } else {
      setState(() {
        print('use cache 2 setState');

        source = Source.cache;

        messagesSnapshot = _collectionReference
            .where('userIdList', arrayContains: uid)
            .orderBy('timestamp')
            .getDocuments(source: source);
      });

      _collectionReference
          .where('userIdList', arrayContains: uid)
          .orderBy('timestamp')
          .getDocuments(source: Source.serverAndCache)
          .then((onValue) {
        print('use server result');
        setState(() {
          messagesSnapshot = Future.sync(() => onValue);
        });
      });
    }

    var messagesSnapshotValue = await messagesSnapshot;

    if ((messagesSnapshotValue.documents).isNotEmpty) {
      for (var doc in (messagesSnapshotValue.documents)) {
        var areAllMessagesRead = (await doc.reference
                .collection('messageList')
                .getDocuments(source: source))
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

      _isLoading = false;
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
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAppBar(),
          (_isLoading == null || _isLoading)
              ? SizedBox.shrink()
              : _buildSearchBar(),
          Expanded(
              child: FutureBuilder(
                  future: messagesSnapshot,
                  builder: (context, snapshot) {
                    if (_isLoading == null || _isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      if (_mapOfConnectedUserToAllMessagesReadStatus
                          .isNotEmpty) {
                        return Container(
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
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No chats found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
                        ),
                      );
                    }
                  })),
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
          height: 15,
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
          : CircleAvatar(backgroundColor: Colors.red, radius: 8.0),
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
