import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  var _newMessageSubscription;
  final CollectionReference _collectionReference =
      Firestore.instance.collection("users");
  bool _newMessagesFirstListenFlag = true;
  List<DocumentSnapshot> _connectedUserList;
  Set<DocumentSnapshot> _indexesWithNewMessagesSet = Set();

  final _newMessageCollectionReference =
      Firestore.instance.collection('messages');

  final _myListKey = GlobalKey<AnimatedListState>();

  Future<DocumentSnapshot> getUserDoc() async {
    final FirebaseUser user = await firebaseAuth.currentUser();
    final uid = user.uid;

    var sameUser = await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot);

    return sameUser;
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });

    _setUpSubscriptions();
  }

  Future<void> _setUpSubscriptions() async {
    final FirebaseUser user = await firebaseAuth.currentUser();
    final uid = user.uid;
    _subscription = _collectionReference.snapshots().listen((datasnapshot) {
      List<DocumentSnapshot> totalUserList = datasnapshot.documents;

      if (totalUserList != null) {
        int userSubscriptionCounter = 0;
        for (var user in totalUserList) {
          _newMessageSubscription = Firestore.instance
              .collection('messages')
              .document(uid)
              .collection(user.data['uid'])
              .snapshots()
              .listen((documentSnapshot) {
            if (_connectedUserList == null) {
              _connectedUserList = [];
            }
            _connectedUserList.add(totalUserList.firstWhere(
                (userFromSnapshot) =>
                    userFromSnapshot.data['uid'] == user.data['uid']));

            int numberOfDocumentChanges =
                documentSnapshot.documentChanges.length;

            if (numberOfDocumentChanges == 0) {
              setState(() {
                //Refresh screen
              });
            } else {
              for (var documentChange in documentSnapshot.documentChanges) {
                if (_newMessagesFirstListenFlag == false) {
                  bool showNewMessageIndicator = false;

                  if (documentSnapshot.documents.last['receiverUid'] == uid) {
                    showNewMessageIndicator = true;
                  }

                  _moveUserToTop(
                      uid: user.data['uid'],
                      showNewMessageIndicator: showNewMessageIndicator);
                }

                if (numberOfDocumentChanges - 1 ==
                    documentSnapshot.documentChanges.indexOf(documentChange)) {
                  userSubscriptionCounter = userSubscriptionCounter + 1;
                }

                if (userSubscriptionCounter == totalUserList.length) {
                  //This is executed when the loop is complete
                  _newMessagesFirstListenFlag = false;

                  setState(() {
                    //Refresh screen
                  });
                }
              }
            }
          });
        }
      }
    });
  }

  _moveUserToTop(
      {@required String uid, @required bool showNewMessageIndicator}) {
    var user = _connectedUserList.firstWhere((userItem) {
      return userItem.data['uid'] == uid;
    });

    var index = _connectedUserList.indexOf(user);

    _connectedUserList.remove(user);

    _myListKey.currentState.removeItem(index, (context, animation) {
      return _buildChatListTile(index, context);
    });

    _connectedUserList.insert(0, user);

    _myListKey.currentState.insertItem(index);

    if (showNewMessageIndicator) {
      _indexesWithNewMessagesSet.add(user);
    }
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
    _subscription.cancel();
    _newMessageSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
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
          flexibleSpace: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              SizedBox(
                height: kBottomNavigationBarHeight,
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(140.0),
      ),
      backgroundColor: Colors.black,
      body: _connectedUserList != null
          ? Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: AnimatedList(
                  initialItemCount: _connectedUserList.length,
                  key: _myListKey,
                  itemBuilder: ((context, index, animation) {
                    return _buildChatListTile(index, context);
                  }),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
              ),
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

  ListTile _buildChatListTile(int index, BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: new BoxDecoration(
          color: Color(0xffc67608), // border color
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundImage:
              NetworkImage(_connectedUserList[index].data['photoUrl']),
        ),
      ),
      title: Text(_connectedUserList[index].data['name'],
          style: TextStyle(
            color: Colors.white,
          )),
      subtitle: Text(
          _connectedUserList[index].data['country'] == null
              ? ''
              : _connectedUserList[index].data['country'],
          style: TextStyle(
            color: Colors.white70,
            fontSize: 17,
          )),
      trailing: _indexesWithNewMessagesSet.contains(_connectedUserList[index])
          ? CircleAvatar(
              backgroundColor: Colors.red,
              radius: 8.0,
            )
          : null,
      onTap: (() {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => ChatScreen(
                    name: _connectedUserList[index].data['name'],
                    photoUrl: _connectedUserList[index].data['photoUrl'],
                    receiverUid: _connectedUserList[index].data['uid'])));
      }),
    );
  }
}
