import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
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
  TextEditingController controllerCountry = TextEditingController();
  TextEditingController controllerProfession = TextEditingController();

  SharedPreferences prefs;

  String uid = '';
  String name = '';
  String aboutMe = '';

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
    name = prefs.getString('name') ?? '';
    aboutMe = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';

    // Force refresh input
    setState(() {});
  }

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

  File _image1;
  File _image2;
  File _image3;
  File _image4;

  Future getImage1() async {
    File image_1 = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image_1 != null) {
      setState(() {
        _image1 = image_1;
        print('Image path $_image1');
      });
    }
  }

  Future getImage2() async {
    File image_2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image_2 != null) {
      setState(() {
        _image2 = image_2;
        print('Image path $_image2');
      });
    }
  }

  Future getImage3() async {
    File image_3 = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image_3 != null) {
      setState(() {
        _image3 = image_3;
        print('Image path $_image3');
      });
    }
  }

  Future getImage4() async {
    File image_4 = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image_4 != null) {
      setState(() {
        _image4 = image_4;
        print('Image path $_image4');
      });
    }
  }

  Future uploadImage1() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName1 = randomString(10);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName1);
    StorageUploadTask uploadTask = reference.putFile(_image1);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          image1 = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({'image1': image1});
        });
      }
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future uploadFile2() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName2 = randomString(10);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName2);
    StorageUploadTask uploadTask = reference.putFile(_image2);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          image2 = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({'image2': image2});
        });
      }
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future uploadFile3() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName3 = randomString(10);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName3);
    StorageUploadTask uploadTask = reference.putFile(_image3);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          image3 = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({'image3': image3});
        });
      }
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future uploadFile4() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName4 = randomString(10);
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName4);
    StorageUploadTask uploadTask = reference.putFile(_image4);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          image4 = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(uid)
              .updateData({'image4': image4});
        });
      }
    });

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future uploadFile() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String fileName1 = uid;
    StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName1);
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

    Fluttertoast.showToast(
        msg: "Picture Saved Succesfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _updateName() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    Firestore.instance.collection('users').document(uid).updateData({
      'name': controllerName.text,
    });

    Fluttertoast.showToast(
        msg: "Name Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _updateStatus() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    Firestore.instance.collection('users').document(uid).updateData({
      'status': controllerStatus.text,
    });

    Fluttertoast.showToast(
        msg: "Status Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _updateAboutme() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    Firestore.instance.collection('users').document(uid).updateData({
      'aboutMe': controllerAboutMe.text,
    });

    Fluttertoast.showToast(
        msg: "Bio Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _updateCountry() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    Firestore.instance.collection('users').document(uid).updateData({
      'country': controllerCountry.text,
    });

    Fluttertoast.showToast(
        msg: "Location Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _updateProfession() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    Firestore.instance.collection('users').document(uid).updateData({
      'profession': controllerProfession.text,
    });

    Fluttertoast.showToast(
        msg: "Profession Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<DocumentSnapshot> getUserDoc() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    return await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) =>
            snapshot); //await needs to be placed here
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
                                  FutureBuilder<DocumentSnapshot>(
                                      future: getUserDoc(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  snapshot.data['photoUrl'],
                                                ),
                                                radius: 50.0,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Container(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        30.0, 20.0, 0.0, 0.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(0xffc67608)),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50.0, 40.0, 0.0, 0.0),
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
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data['name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'RalewayRegular',
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data['country'],
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
                                );
                              } else {
                                return Container();
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
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              onPressed: uploadFile,
                              child: Text(
                                'Save Picture',
                                style: TextStyle(
                                  color: Color(0xffc67608),
                                  fontSize: 19,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(270.0),
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
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                              future: getUserDoc(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data['aboutMe'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'Loading Details....',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        (_image1 == null)
                            ? (image1 != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  themeColor),
                                        ),
                                        width: 90.0,
                                        height: 90.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: image1,
                                      width: 167.0,
                                      height: 111.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      FutureBuilder<DocumentSnapshot>(
                                          future: getUserDoc(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                      snapshot.data['image1'],
                                                    ),
                                                    width: 167,
                                                    height: 111,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40.0, 70.0, 0.0, 0.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Color(0xffc67608),
                                          ),
                                          onPressed: getImage1,
                                          padding: EdgeInsets.all(30.0),
                                          splashColor: Colors.transparent,
                                          highlightColor: greyColor,
                                          iconSize: 28.0,
                                        ),
                                      ),
                                    ],
                                  ))
                            : Material(
                                child: Container(
                                  width: 167.0,
                                  height: 111.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: Image.file(
                                    _image1,
                                    width: 167.0,
                                    height: 111.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        (_image2 == null)
                            ? (image2 != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  themeColor),
                                        ),
                                        width: 90.0,
                                        height: 90.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: image2,
                                      width: 167.0,
                                      height: 111.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      FutureBuilder<DocumentSnapshot>(
                                          future: getUserDoc(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
                                                width: 167.0,
                                                height: 111.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                      snapshot.data['image2'],
                                                    ),
                                                    width: 167,
                                                    height: 111,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40.0, 70.0, 0.0, 0.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Color(0xffc67608),
                                          ),
                                          onPressed: getImage2,
                                          padding: EdgeInsets.all(30.0),
                                          splashColor: Colors.transparent,
                                          highlightColor: greyColor,
                                          iconSize: 28.0,
                                        ),
                                      ),
                                    ],
                                  ))
                            : Material(
                                child: Container(
                                  width: 167.0,
                                  height: 111.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: Image.file(
                                    _image2,
                                    width: 167.0,
                                    height: 111.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        (_image3 == null)
                            ? (image3 != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  themeColor),
                                        ),
                                        width: 90.0,
                                        height: 90.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: image3,
                                      width: 167.0,
                                      height: 111.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      FutureBuilder<DocumentSnapshot>(
                                          future: getUserDoc(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
                                                width: 167.0,
                                                height: 111.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                      snapshot.data['image3'],
                                                    ),
                                                    width: 167,
                                                    height: 111,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40.0, 70.0, 0.0, 0.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Color(0xffc67608),
                                          ),
                                          onPressed: getImage3,
                                          padding: EdgeInsets.all(30.0),
                                          splashColor: Colors.transparent,
                                          highlightColor: greyColor,
                                          iconSize: 28.0,
                                        ),
                                      ),
                                    ],
                                  ))
                            : Material(
                                child: Container(
                                  width: 167.0,
                                  height: 111.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: Image.file(
                                    _image3,
                                    width: 167.0,
                                    height: 111.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        (_image4 == null)
                            ? (image4 != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  themeColor),
                                        ),
                                        width: 90.0,
                                        height: 90.0,
                                        padding: EdgeInsets.all(20.0),
                                      ),
                                      imageUrl: image4,
                                      width: 167.0,
                                      height: 111.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Stack(
                                    children: <Widget>[
                                      FutureBuilder<DocumentSnapshot>(
                                          future: getUserDoc(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
                                                width: 167.0,
                                                height: 111.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                      snapshot.data['image4'],
                                                    ),
                                                    width: 167,
                                                    height: 111,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40.0, 70.0, 0.0, 0.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Color(0xffc67608),
                                          ),
                                          onPressed: getImage4,
                                          padding: EdgeInsets.all(30.0),
                                          splashColor: Colors.transparent,
                                          highlightColor: greyColor,
                                          iconSize: 28.0,
                                        ),
                                      ),
                                    ],
                                  ))
                            : Material(
                                child: Container(
                                  width: 167.0,
                                  height: 111.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: Image.file(
                                    _image4,
                                    width: 167.0,
                                    height: 111.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                clipBehavior: Clip.hardEdge,
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
                          "Upload Images",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        textColor: Colors.black,
                        onPressed: () {
                          uploadImage1();
                          uploadFile2();
                          uploadFile3();
                          uploadFile4();
                        },
                      ),
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
                child: FutureBuilder<DocumentSnapshot>(
                    future: getUserDoc(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
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
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 65,
                                    ),
                                    Text(
                                      snapshot.data['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 65,
                                    ),
                                    Text(
                                      snapshot.data['status'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 65,
                                    ),
                                    Text(
                                      snapshot.data['country'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 32.0, 16.0),
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
                                                borderSide: BorderSide(
                                                    color: Color(0xffc67608))),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: controllerName,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            onPressed: _updateName,
                                            child: Text(
                                              'save',
                                              style: TextStyle(
                                                color: Color(0xffc67608),
                                                fontSize: 19,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 32.0, 16.0),
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
                                                borderSide: BorderSide(
                                                    color: Color(0xffc67608))),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: controllerStatus,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            onPressed: _updateStatus,
                                            child: Text(
                                              'Save',
                                              style: TextStyle(
                                                color: Color(0xffc67608),
                                                fontSize: 19,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 32.0, 16.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Location',
                                            filled: true,
                                            fillColor: Colors.black,
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            focusColor: Colors.white,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffc67608))),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: controllerCountry,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            onPressed: _updateCountry,
                                            child: Text(
                                              'save',
                                              style: TextStyle(
                                                color: Color(0xffc67608),
                                                fontSize: 19,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 32.0, 16.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Profession',
                                            filled: true,
                                            fillColor: Colors.black,
                                            labelStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            focusColor: Colors.white,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffc67608))),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: controllerProfession,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            onPressed: _updateProfession,
                                            child: Text(
                                              'save',
                                              style: TextStyle(
                                                color: Color(0xffc67608),
                                                fontSize: 19,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 16.0, 32.0, 16.0),
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
                                                borderSide: BorderSide(
                                                    color: Color(0xffc67608))),
                                          ),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: controllerAboutMe,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            onPressed: _updateAboutme,
                                            child: Text(
                                              'save',
                                              style: TextStyle(
                                                color: Color(0xffc67608),
                                                fontSize: 19,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Loading Details....',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
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
                  color: Color(0xffc67608),
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
                  color: Color(0xffc67608),
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
