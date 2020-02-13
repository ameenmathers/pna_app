import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Meetup extends StatefulWidget {
  @override
  State createState() => MeetupState();
}

class MeetupState extends State<Meetup> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> _sameCountryUsersDocumentSnapshotList;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("users");

  @override
  void initState() {
    super.initState();
    _getSameCountryUsers();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  Future<List<DocumentSnapshot>> getDocumentSnapshotListOfSameCountryUsers(
      {@required String country, @required Source source}) async {
    QuerySnapshot querySnapshot = await _usersCollectionReference
        .where('country', isEqualTo: country)
        .getDocuments(source: source);

    return querySnapshot.documents;
  }

  Future<void> _getSameCountryUsers() async {
    setState(() {
      _isLoading = true;
    });
    final FirebaseUser user = await firebaseAuth.currentUser();
    final uid = user.uid;
    List<DocumentSnapshot> usersList;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      try {
        DocumentSnapshot userProfileInfo = await _usersCollectionReference
            .document(uid)
            .get(source: Source.cache);

        String country = userProfileInfo.data['country'];

        usersList = await getDocumentSnapshotListOfSameCountryUsers(
            country: country, source: Source.cache);

        print('cache');
      } catch (e) {
        DocumentSnapshot userProfileInfo = await _usersCollectionReference
            .document(uid)
            .get(source: Source.serverAndCache);

        String country = userProfileInfo.data['country'];

        usersList = await getDocumentSnapshotListOfSameCountryUsers(
            country: country, source: Source.serverAndCache);
        print('server');
      }
    } else {
      DocumentSnapshot userProfileInfo = await _usersCollectionReference
          .document(uid)
          .get(source: Source.cache);

      String country = userProfileInfo.data['country'];

      usersList = await getDocumentSnapshotListOfSameCountryUsers(
          country: country, source: Source.cache);

      print('cache 2');

      _usersCollectionReference
          .document(uid)
          .get(source: Source.cache)
          .then((snapshot) {
        String country = snapshot.data['country'];
        getDocumentSnapshotListOfSameCountryUsers(
                country: country, source: Source.cache)
            .then((snapshot) {
          setState(() {
            print('server 2');

            usersList = snapshot;
          });
        });
      });
    }

    setState(() {
      _sameCountryUsersDocumentSnapshotList = usersList;
      _isLoading = false;
    });
  }

  bool _isLoading = false;

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
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
                    ),
                  )
                : _sameCountryUsersDocumentSnapshotList.isEmpty
                    ? Center(
                        child: Text('No connections found'),
                      )
                    : _buildUsersList(),
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
                color: Color(0xffc67608),
              ),
              onPressed: () {},
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.grey,
              ),
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
          "Message",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        textColor: Color(0xffc67608),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        name: userDataMap['name'],
                        photoUrl: userDataMap['photoUrl'],
                        receiverUid: userDataMap['uid'],
                        country: userDataMap['country'],
                      )));
        },
      ),
      onTap: (() {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => ViewProfile(
                    name: userDataMap['name'],
                    profession: userDataMap['profession'],
                    country: userDataMap['country'],
                    aboutMe: userDataMap['aboutMe'],
                    gender: userDataMap['gender'],
                    photoUrl: userDataMap['photoUrl'],
                    images: userDataMap['images'],
                    uid: userDataMap['uid'])));
      }),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 10.0,
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
          height: 10,
        ),
        Text(
          'Search for PNA members around you'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Connections'.toUpperCase(),
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
}

class ViewProfile extends StatefulWidget {
  String name;
  String country;
  String aboutMe;
  String profession;
  String gender;
  String photoUrl;
  final List images;
  String uid;

  ViewProfile(
      {this.name,
      this.photoUrl,
      this.uid,
      this.aboutMe,
      this.country,
      this.gender,
      this.profession,
      this.images});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  DocumentSnapshot documentSnapshot;

  PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  void goBack() {
    scaleStateController.scaleState = PhotoViewScaleState.originalSize;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.photoUrl),
                        radius: 50.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          style: BorderStyle.solid,
                          color: Color(0xffc67608),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      name: widget.name,
                                      photoUrl: widget.photoUrl,
                                      receiverUid: widget.uid,
                                      country: widget.country,
                                    )));
                      },
                      child: Text(
                        'Message',
                        style: TextStyle(
                          color: Color(0xffc67608),
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.country.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RalewayRegular',
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.profession.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RalewayRegular',
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.gender.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'RalewayRegular',
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 190,
                  child: Divider(
                    height: 10,
                    color: Color(0xffc67608),
                    thickness: 4,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.aboutMe,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (widget.images == null || widget.images.isEmpty)
                ? Container()
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                          alignment: WrapAlignment.start,
                          children: widget.images
                              .map((imageUrl) => ProfileImageItem(
                                    imageUrl: imageUrl,
                                  ))
                              .toList()),
                    ),
                  ),
            SizedBox(
              height: 35,
            ),
          ],
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
                color: Color(0xffc67608),
              ),
              onPressed: () {},
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.grey,
              ),
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
}
