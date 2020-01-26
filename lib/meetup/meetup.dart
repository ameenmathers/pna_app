import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/image/image1.dart';
import 'package:travel_world/image/image2.dart';
import 'package:travel_world/image/image3.dart';
import 'package:travel_world/image/image4.dart';
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
  DocumentSnapshot userProfileInfo;
  List<DocumentSnapshot> usersList;
  final CollectionReference _collectionReference =
      Firestore.instance.collection("users");

  @override
  void initState() {
    super.initState();
    getUserDoc();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  void getUsersList() {
    _subscription = _collectionReference
        .where('country', isEqualTo: userProfileInfo.data['country'])
        .snapshots()
        .listen((datasnapshot) {
      setState(() {
        usersList = datasnapshot.documents;
        print("Users List ${usersList.length}");
      });
    });
  }

  Future<DocumentSnapshot> getUserDoc() async {
    final FirebaseUser user = await firebaseAuth.currentUser();
    final uid = user.uid;

    userProfileInfo = await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot);

    getUsersList();

    return userProfileInfo; //await needs to be placed here
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            'Connections'.toUpperCase(),
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
                height: 100,
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
              Text(
                'Search for PNA members around you'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(140.0),
      ),
      backgroundColor: Colors.black,
      body: usersList != null
          ? Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: usersList.length,
                  itemBuilder: ((context, index) {
                    return filter == null || filter == ""
                        ? ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: new BoxDecoration(
                                color: Color(0xffc67608), // border color
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: NetworkImage(
                                    usersList[index].data['photoUrl']),
                              ),
                            ),
                            title: Text(usersList[index].data['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            subtitle: Text(usersList[index].data['country'],
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
                                            name: usersList[index].data['name'],
                                            photoUrl: usersList[index]
                                                .data['photoUrl'],
                                            receiverUid:
                                                usersList[index].data['uid'])));
                              },
                            ),
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => ViewProfile(
                                          name: usersList[index].data['name'],
                                          profession: usersList[index]
                                              .data['profession'],
                                          country:
                                              usersList[index].data['country'],
                                          aboutMe:
                                              usersList[index].data['aboutMe'],
                                          gender:
                                              usersList[index].data['gender'],
                                          photoUrl:
                                              usersList[index].data['photoUrl'],
                                          image1:
                                              usersList[index].data['image1'],
                                          image2:
                                              usersList[index].data['image2'],
                                          image3:
                                              usersList[index].data['image3'],
                                          image4:
                                              usersList[index].data['image4'],
                                          uid: usersList[index].data['uid'])));
                            }),
                          )
                        : usersList[index]
                                .data['country']
                                .toLowerCase()
                                .contains(filter.toLowerCase())
                            ? ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      usersList[index].data['photoUrl']),
                                ),
                                title: Text(usersList[index].data['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                                subtitle: Text(usersList[index].data['country'],
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
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
                                    "Connect",
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
                                                name: usersList[index]
                                                    .data['name'],
                                                photoUrl: usersList[index]
                                                    .data['photoUrl'],
                                                receiverUid: usersList[index]
                                                    .data['uid'])));
                                  },
                                ),
                                onTap: (() {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => ViewProfile(
                                              name:
                                                  usersList[index].data['name'],
                                              profession: usersList[index]
                                                  .data['profession'],
                                              country: usersList[index]
                                                  .data['country'],
                                              aboutMe: usersList[index]
                                                  .data['aboutMe'],
                                              gender: usersList[index]
                                                  .data['gender'],
                                              photoUrl: usersList[index]
                                                  .data['photoUrl'],
                                              image1: usersList[index]
                                                  .data['image1'],
                                              image2: usersList[index]
                                                  .data['image2'],
                                              image3: usersList[index]
                                                  .data['image3'],
                                              image4: usersList[index]
                                                  .data['image4'],
                                              uid: usersList[index]
                                                  .data['uid'])));
                                }),
                              )
                            : new Container();
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

class ViewProfile extends StatefulWidget {
  String name;
  String country;
  String aboutMe;
  String profession;
  String gender;
  String photoUrl;
  String image1;
  String image2;
  String image3;
  String image4;
  String uid;

  ViewProfile(
      {this.name,
      this.photoUrl,
      this.uid,
      this.aboutMe,
      this.country,
      this.gender,
      this.profession,
      this.image1,
      this.image2,
      this.image3,
      this.image4});

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
                                    receiverUid: widget.uid)));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: (() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Image1(
                                  image1: widget.image1,
                                )));
                  }),
                  child: Hero(
                    tag: widget.image1,
                    child: Container(
                      width: 167.0,
                      height: 111.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                          image: NetworkImage(widget.image1),
                          placeholder: AssetImage(''),
                          width: 167.0,
                          height: 111.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Image2(
                                  image2: widget.image2,
                                )));
                  }),
                  child: Hero(
                    tag: widget.image2,
                    child: Container(
                      width: 167.0,
                      height: 111.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                          image: NetworkImage(widget.image2),
                          placeholder: AssetImage(''),
                          width: 167.0,
                          height: 111.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: (() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Image3(
                                  image3: widget.image3,
                                )));
                  }),
                  child: Hero(
                    tag: widget.image3,
                    child: Container(
                      width: 167.0,
                      height: 111.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                          image: NetworkImage(widget.image3),
                          placeholder: AssetImage(''),
                          width: 167.0,
                          height: 111.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Image4(
                                  image4: widget.image4,
                                )));
                  }),
                  child: Hero(
                    tag: widget.image4,
                    child: Container(
                      width: 167.0,
                      height: 111.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                          image: NetworkImage(widget.image4),
                          placeholder: AssetImage(''),
                          width: 167.0,
                          height: 111.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
