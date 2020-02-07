import 'dart:async';
import 'dart:convert' as converter;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:travel_world/const.dart';
import 'package:travel_world/full_screen_image.dart';
import 'package:travel_world/home/home.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/editprofile.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  State createState() => ProfileState();
}

class ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  final int maxNumberOfImages = 20;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserDoc();
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

  String photoUrl = '';
  String image1 = '';
  String image2 = '';
  String image3 = '';
  String image4 = '';

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

  File _imageFromGallery;

  Future getImageFromGallery() async {
    File imageFileFromGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFileFromGallery != null) {
      setState(() {
        _imageFromGallery = imageFileFromGallery;
        print('Image path $_imageFromGallery');
      });
    }
  }

  Future uploadImageFromGallery() async {
    setState(() {
      isLoading = true;
    });
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName1 = randomString(10);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName1);
    StorageUploadTask uploadTask = reference.putFile(_imageFromGallery);
    StorageTaskSnapshot storageTaskSnapshot;
    storageTaskSnapshot = await uploadTask.onComplete;

    photoUrl = await storageTaskSnapshot.ref.getDownloadURL();

    image1 = photoUrl;

    await Firestore.instance.collection('users').document(uid).setData({
      'images': FieldValue.arrayUnion([image1]),
    }, merge: true);
    setState(() {
      isLoading = false;
      _imageFromGallery = null;
      print(' not loading');
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });

    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName1 = uid;
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName1);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;

    storageTaskSnapshot = await uploadTask.onComplete;

    photoUrl = await storageTaskSnapshot.ref.getDownloadURL();

    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'photoUrl': photoUrl});

    setState(() {
      isLoading = false;
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  Future<DocumentSnapshot> userDocumentSnapshot;

  Future<void> getUserDoc() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      try {
        print(' No internet => Loading from cache');
        var snapshot = Firestore.instance
            .collection('users')
            .document(uid)
            .get(source: Source.cache);

        setState(() {
          userDocumentSnapshot = snapshot;
        });
      } catch (e) {
        print(' No internet, error retrieving cache => Loading from server');
        var snapshot = Firestore.instance
            .collection('users')
            .document(uid)
            .get(source: Source.serverAndCache);
        setState(() {
          userDocumentSnapshot = snapshot;
        });
      }
    } else {
      print(' Internet => Loading from server');

      Firestore.instance
          .collection('users')
          .document(uid)
          .get(source: Source.serverAndCache)
          .then((onValue) {
        print('data from server');
        setState(() {
          print('data from server setState');

          userDocumentSnapshot = Future.sync(() => onValue);
        });
      });
      var snapshot = Firestore.instance
          .collection('users')
          .document(uid)
          .get(source: Source.cache);

      setState(() {
        print('cache data');
        userDocumentSnapshot = snapshot;
      });
    }
  }

  var myFile = new File('pro.txt');

  Future<void> deleteImageFromFirestore(String imageUrl) async {
    print('delete this $imageUrl');

    setState(() {
      isLoading = true;
    });

    try {
      final FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;

      await Firestore.instance.collection('users').document(uid).setData({
        'images': FieldValue.arrayRemove([imageUrl]),
      }, merge: true);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Picture Deleted Succesfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Color(0xffc67608),
          textColor: Colors.white,
          fontSize: 14.0);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Error in Deleting Picture ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Color(0xffc67608),
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          RaisedButton(
            color: Colors.black,
            child: Text(
              "Log Out",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              _auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FutureBuilder<DocumentSnapshot>(
                                future: userDocumentSnapshot,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: new BoxDecoration(
                                            color: Color(
                                                0xffc67608), // border color
                                            shape: BoxShape.circle,
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              snapshot.data['photoUrl'],
                                            ),
                                            radius: 50.0,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30.0, 20.0, 0.0, 0.0),
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(0xffc67608)),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<DocumentSnapshot>(
                    future: userDocumentSnapshot,
                    builder: (context, snapshot) {
                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        name: snapshot.data['name'],
                                        bio: snapshot.data['aboutMe'],
                                        profession: snapshot.data['profession'],
                                        country: snapshot.data['country'],
                                      ),
                                    ));
                              },
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Color(0xffc67608),
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                              onPressed: _referURL,
                              child: Text(
                                'Refer Member',
                                style: TextStyle(
                                  color: Color(0xffc67608),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: FutureBuilder<DocumentSnapshot>(
                      future: userDocumentSnapshot,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['name'] == null
                                        ? ''
                                        : snapshot.data['name']
                                            .toString()
                                            .toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'RalewayRegular',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['country'] == null
                                        ? ''
                                        : snapshot.data['country']
                                            .toString()
                                            .toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'RalewayRegular',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['profession'].toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'RalewayRegular',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: FutureBuilder<DocumentSnapshot>(
                        future: userDocumentSnapshot,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> imageUrlList =
                                snapshot.data['images'];

                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['aboutMe'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _imageFromGallery == null
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffc67608)),
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            onPressed: (imageUrlList != null &&
                                                    imageUrlList.length > 20)
                                                ? showLimitErrorSnackbar
                                                : getImageFromGallery,
                                            icon: Icon(
                                              Icons.camera_alt,
                                              color: Color(0xffc67608),
                                            ),
                                          ),
                                        )
                                      : Image.file(_imageFromGallery),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
                _imageFromGallery == null
                    ? Container()
                    : ButtonTheme(
                        minWidth: 300.0,
                        height: 40.0,
                        child: RaisedButton(
                          color: Color(0xffc67608),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xffc67608),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Save Image",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          textColor: Colors.black,
                          onPressed: uploadImageFromGallery,
                        ),
                      ),
                FutureBuilder<DocumentSnapshot>(
                    future: userDocumentSnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> imageUrlList = snapshot.data['images'];

                        if (imageUrlList == null || imageUrlList.isEmpty) {
                          return Container();
                        } else {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: imageUrlList
                                      .map((imageUrl) => ProfileImageItem(
                                            imageUrl: imageUrl,
                                            deleteImage:
                                                deleteImageFromFirestore,
                                          ))
                                      .toList()),
                            ),
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
          isLoading
              ? Positioned(
                  top: 0.0,
                  left: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                  ),
                )
              : SizedBox.shrink(),
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
                Icons.person,
                color: Color(0xffc67608),
              ),
              onPressed: () {},
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }

  showLimitErrorSnackbar() {
    final snackBar =
        SnackBar(content: Text('Can not upload more than 20 images'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}

class ProfileImageItem extends StatelessWidget {
  final String imageUrl;
  final Function(String) deleteImage;

  const ProfileImageItem({Key key, @required this.imageUrl, this.deleteImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageUrl,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imageUrl: imageUrl)));
                },
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    ),
                  ),
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: InkWell(
              onTap: () => deleteImage(imageUrl),
              child: Icon(
                Icons.remove_circle,
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

_referURL() async {
  const url = 'https://playnetwork.africa/refer-member';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class User {
  final int uid;
  final String name;
  final String aboutMe;
  final String country;
  final String city;
  final String profession;
  final String photoUrl;
  final String image1;
  final String image2;
  final String image3;
  final String image4;

  User(
      {this.uid,
      this.name,
      this.aboutMe,
      this.country,
      this.city,
      this.profession,
      this.photoUrl,
      this.image1,
      this.image2,
      this.image3,
      this.image4});

  factory User.fromMap(Map data) {
    return User(
      name: data['name'],
      aboutMe: data['aboutMe'],
      country: data['country'],
      city: data['city'],
      profession: data['profession'],
      photoUrl: data['photoUrl'],
      image1: data['image1'],
      image2: data['image2'],
      image3: data['image3'],
      image4: data['image4'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'aboutMe': aboutMe,
      'country': country,
      'city': city,
      'profession': profession,
      'photoUrl': photoUrl,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
    };
  }
}
