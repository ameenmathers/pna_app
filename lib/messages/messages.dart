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

  List<DocumentSnapshot> _connectedUserList;

  final _myListKey = GlobalKey<AnimatedListState>();

  String uid;

  @override
  void initState() {
    super.initState();
    _getMessages();
    _setUpSubscription();

    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
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

    setState(() {
      if (snapshot.documents.isEmpty) {
        _connectedUserList = [];
      } else {
        var tempList = snapshot.documents
            .where((snapshot) =>
                (snapshot.data['userIdList'] as List).contains(uid))
            .toList();
        if (snapshot.documents.length > 1) {
          tempList.sort((a, b) => (b.data['timestamp'] as Timestamp)
              .compareTo(a.data['timestamp'] as Timestamp));
        }

        _connectedUserList = tempList;
      }
    });
  }

  StreamSubscription<QuerySnapshot> _setUpSubscription() {
    return _subscription = _collectionReference.snapshots().listen(
      (datasnapshot) {
        setState(
          () {
            _getMessages();
          },
        );
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
            child: _connectedUserList != null
                ? _connectedUserList.isEmpty
                    ? Center(
                        child: Text(
                          'No chats found',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(
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
      backgroundColor: Colors.black,
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
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  ListTile _buildChatListTile(int index, BuildContext context) {
    String otherUserId = ((_connectedUserList[index].data['userIdList'] as List)
        .singleWhere((uidFromList) => uidFromList != uid, orElse: () => uid));

    String otherName = (_connectedUserList[index].data['mapOfUidToUsername']
        as Map)[otherUserId];
    String otherPhotoUrl = (_connectedUserList[index].data['mapOfUidToPhotoUrl']
        as Map)[otherUserId];
    String otherCountry = (_connectedUserList[index].data['mapOfUidToCountry']
        as Map)[otherUserId];

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
          _getMessages(); //Refresh screen
        });
      }),
    );
  }
}
