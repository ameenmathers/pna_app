import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';

class ProfileSettings extends StatefulWidget {
  @override
  State createState() => ProfileSettingsState();
}

class ProfileSettingsState extends State<ProfileSettings> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> _sameCountryUsersDocumentSnapshotList;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");

  @override
  void initState() {
    super.initState();
    _getSameCountryUsers();
  }

//  Future<void> getUserDoc() async {
//    final FirebaseUser user = await firebaseAuth.currentUser();
//    final uid = user.uid;
//
//    var snapshot = Firestore.instance
//        .collection('users')
//        .document(uid)
//        .where('blockedUsers': arrayContaines: blockedUsers)
//        .get();
//  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  Future<List<DocumentSnapshot>> getDocumentSnapshotListOfSameCountryUsers(
      {@required String country}) async {
    QuerySnapshot querySnapshot = await _usersCollectionReference
        .where('country', isEqualTo: country)
        .getDocuments();

    return querySnapshot.documents;
  }

  Future<void> _getSameCountryUsers() async {
    final FirebaseUser user = await firebaseAuth.currentUser();
    final uid = user.uid;

    DocumentSnapshot userProfileInfo =
        await _usersCollectionReference.document(uid).get();

    String country = userProfileInfo.data['country'];
    List<dynamic> blockedUsers = userProfileInfo.data['blockedUsers'];

    List<DocumentSnapshot> usersList =
        await getDocumentSnapshotListOfSameCountryUsers(country: country)
            .then((v) {
      print(v);
      return Future.value(v);
    });

    List<DocumentSnapshot> correctUsersList = usersList.where((element) {
      return blockedUsers.contains(element.data['uid']);
    }).toList();

    setState(() {
      _sameCountryUsersDocumentSnapshotList = correctUsersList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAppBar(),
          Expanded(
            child: _sameCountryUsersDocumentSnapshotList != null
                ? _buildUsersList()
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
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Messages()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.person,
                color: Color(0xffc67608),
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
              onPressed: () {},
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _sameCountryUsersDocumentSnapshotList.length,
        itemBuilder: ((context, index) {
          return filter == null || filter == ""
              ? _buildUserListTile(
                  userDataMap:
                      _sameCountryUsersDocumentSnapshotList[index].data,
                  context: context)
              : _sameCountryUsersDocumentSnapshotList[index]
                      .data['name']
                      .toLowerCase()
                      .contains(filter.toLowerCase())
                  ? _buildUserListTile(
                      userDataMap:
                          _sameCountryUsersDocumentSnapshotList[index].data,
                      context: context)
                  : SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildUserListTile(
      {@required Map userDataMap, @required BuildContext context}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: new BoxDecoration(
          color: Color(0xffc67608), // border color
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.black,
          backgroundImage: NetworkImage(userDataMap['photoUrl']),
        ),
      ),
      title: Text(userDataMap['name'],
          style: TextStyle(
            color: Colors.white,
          )),
      subtitle: Text(userDataMap['country'],
          style: TextStyle(
            color: Colors.white70,
            fontSize: 17,
          )),
      trailing: RaisedButton(
        onPressed: () async {
          final FirebaseUser user = await firebaseAuth.currentUser();
          final uid = user.uid;

          String keyid = userDataMap['uid'];

          print('delete this $keyid');

          Firestore.instance.collection('users').document(uid).updateData({
            'blockedUsers': FieldValue.arrayRemove([keyid])
          });

          Fluttertoast.showToast(
              msg: "User Unblocked",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Color(0xffc67608),
              textColor: Colors.white,
              fontSize: 14.0);
        },
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            style: BorderStyle.solid,
            color: Color(0xffc67608),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Text(
          "Unblock",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xffc67608),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Blocked Users'.toUpperCase(),
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
}
