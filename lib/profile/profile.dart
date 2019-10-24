import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_world/const.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  State createState() => ProfileState();
}

class ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  TabController tabController;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAboutMe = TextEditingController();
  TextEditingController controllerStatus = TextEditingController();

  SharedPreferences prefs;

  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        print('Image path $avatarImageFile');
      });
    }
  }

  Future uploadFile() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName = uid;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({'photoUrl': photoUrl});
        });
      }
    });
  }

  void _updateData() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    Firestore.instance.collection('users').document(uid).updateData({
      'name': controllerName.text,
      'aboutMe': controllerAboutMe.text,
      'status': controllerStatus.text,
      'photoUrl': photoUrl,
    });
  }

  Future<DocumentSnapshot> getUserDoc() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    Firestore.instance.collection('users').document(uid).snapshots();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  child: Text("ABOUT"),
                ),
                Tab(
                  child: Text("SETTINGS"),
                ),
              ],
              indicatorColor: Color(0xffc67608),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    (avatarImageFile == null)
                        ? (photoUrl != ''
                            ? Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          themeColor),
                                    ),
                                    width: 90.0,
                                    height: 90.0,
                                    padding: EdgeInsets.all(20.0),
                                  ),
                                  imageUrl: photoUrl,
                                  width: 100.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              )
                            : Stack(
                                children: <Widget>[
                                  Icon(
                                    Icons.account_circle,
                                    size: 120.0,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        55.0, 55.0, 0.0, 0.0),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Color(0xffc67608),
                                      ),
                                      onPressed: getImage,
                                      padding: EdgeInsets.all(30.0),
                                      splashColor: Colors.transparent,
                                      highlightColor: greyColor,
                                      iconSize: 30.0,
                                    ),
                                  ),
                                ],
                              ))
                        : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                            future: getUserDoc(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount: snapshot.data['data'].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data["name"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data["aboutMe"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                return Container(
                                  child: Text(
                                    'text',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                            }),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Connections',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'RalewayRegular',
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(250.0),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Edit Description',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                'Nigeria',
//                                textAlign: TextAlign.left,
//                                style: TextStyle(
//                                  fontSize: 16,
//                                  color: Colors.white,
//                                ),
//                              )
//                            ],
//                          ),
//                          SizedBox(
//                            height: 10,
//                          ),
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                'Software Developer',
//                                textAlign: TextAlign.left,
//                                style: TextStyle(
//                                  fontSize: 16,
//                                  color: Colors.white,
//                                ),
//                              )
//                            ],
//                          ),
//                          SizedBox(
//                            height: 10,
//                          ),
//                          Text(
//                            'Traveler that loves wings and plays games on my free time',
//                            textAlign: TextAlign.left,
//                            style: TextStyle(
//                              fontSize: 16,
//                              color: Colors.white,
//                            ),
//                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: AssetImage('images/pro.png'),
                            width: 167,
                            height: 111,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: AssetImage('images/pro1.png'),
                            width: 167,
                            height: 111,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: AssetImage('images/pro3.png'),
                            width: 167,
                            height: 111,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: AssetImage('images/pro4.png'),
                            width: 167,
                            height: 111,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                        color: Color(0xffc67608),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xffc67608),
                          ),
                        ),
                        child: Text(
                          "Refer Member",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        textColor: Colors.black,
                        onPressed: _referURL,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 65,
                            ),
                            Text(
                              'Username',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Ameen Idris',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            RaisedButton(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Text("Edit"),
                              textColor: Colors.orangeAccent,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 65,
                            ),
                            Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "I'm Available",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            RaisedButton(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Text("Edit"),
                              textColor: Colors.orangeAccent,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 65,
                            ),
                            Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Abuja, Nigeria',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            RaisedButton(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Text("Edit"),
                              textColor: Colors.orangeAccent,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Name',
                              filled: true,
                              fillColor: Colors.black,
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              focusColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.orangeAccent)),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: controllerName,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Status',
                              filled: true,
                              fillColor: Colors.black,
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              focusColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.orangeAccent)),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: controllerStatus,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                          child: TextFormField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Bio',
                              filled: true,
                              fillColor: Colors.black,
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              focusColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.orangeAccent)),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: controllerAboutMe,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          minWidth: 300.0,
                          height: 40.0,
                          child: RaisedButton(
                            color: Color(0xffc67608),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffc67608),
                              ),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            textColor: Colors.black,
                            onPressed: _updateData,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                  color: Colors.orangeAccent,
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
                  color: Colors.orangeAccent,
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
                  color: Colors.orangeAccent,
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
                  color: Colors.orangeAccent,
                ),
                onPressed: () {},
              ),
              title: Text(''),
            ),
          ],
        ),
      ),
    );
  }
}

_referURL() async {
  const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
