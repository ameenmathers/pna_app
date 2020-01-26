import 'dart:async';
import 'dart:convert' as converter;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:travel_world/const.dart';
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

  Future<DocumentSnapshot> getUserDoc({bool useCache = true}) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    print('Loading Profile');

    String data;

    /// Do we have a cache we can use?
    var cache = await cacheExists();

    /// If the cache exists and it contains data use that, otherwise we call the API
    if (cache && useCache) {
      print('We have cached data');

      data = await readToFile();

      var cacheData = converter.jsonDecode(data);
    } else {
      print('No cache. Fetching from API');

      var sameUser =
          await Firestore.instance.collection('users').document(uid).get();

      var apiData = converter.jsonEncode(sameUser.data);

      data = apiData;

      /// Now save the fetched data to the cache
      await writeToFile(data);
    }

    var sameUser = await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot);

    return sameUser;
    //await needs to be placed here
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get myfile async {
    final path = await _localPath;
    return File('$path/pro.txt');
  }

  static Future<bool> cacheExists() async {
    var file = await myfile;

    return file.exists();
  }

  static writeToFile(sameUser) async {
    final file = await myfile;
    file.writeAsString(sameUser);
  }

  static readToFile() async {
    try {
      final file = await myfile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {}
  }

  var myFile = new File('pro.txt');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
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
                              future: getUserDoc(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(3.0),
                                        decoration: new BoxDecoration(
                                          color:
                                              Color(0xffc67608), // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Row(
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
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      },
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Color(0xffc67608),
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                child: FutureBuilder<DocumentSnapshot>(
                    future: getUserDoc(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data['name'].toUpperCase(),
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
                                  snapshot.data['country'].toUpperCase(),
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
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          FutureBuilder<DocumentSnapshot>(
                              future: getUserDoc(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                    ),
                                  );
                                } else {
                                  return Container();
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
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                (_image1 == null)
                                    ? (image1 != ''
                                        ? Material(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(themeColor),
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
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image(
                                                            image: NetworkImage(
                                                              snapshot.data[
                                                                  'image1'],
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
                                            ],
                                          ))
                                    : Material(
                                        child: Container(
                                          width: 167.0,
                                          height: 111.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          child: Image.file(
                                            _image1,
                                            width: 167.0,
                                            height: 111.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  90.0, 70.0, 0.0, 0.0),
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
                        ),
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                (_image2 == null)
                                    ? (image2 != ''
                                        ? Material(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(themeColor),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Colors.white,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image(
                                                            image: NetworkImage(
                                                              snapshot.data[
                                                                  'image2'],
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
                                            ],
                                          ))
                                    : Material(
                                        child: Container(
                                          width: 167.0,
                                          height: 111.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          child: Image.file(
                                            _image2,
                                            width: 167.0,
                                            height: 111.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  90.0, 70.0, 0.0, 0.0),
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                (_image3 == null)
                                    ? (image3 != ''
                                        ? Material(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(themeColor),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Colors.white,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image(
                                                            image: NetworkImage(
                                                              snapshot.data[
                                                                  'image3'],
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
                                            ],
                                          ))
                                    : Material(
                                        child: Container(
                                          width: 167.0,
                                          height: 111.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          child: Image.file(
                                            _image3,
                                            width: 167.0,
                                            height: 111.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  90.0, 70.0, 0.0, 0.0),
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
                        ),
                        Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                (_image4 == null)
                                    ? (image4 != ''
                                        ? Material(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(themeColor),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Colors.white,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image(
                                                            image: NetworkImage(
                                                              snapshot.data[
                                                                  'image4'],
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
                                            ],
                                          ))
                                    : Material(
                                        child: Container(
                                          width: 167.0,
                                          height: 111.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                          child: Image.file(
                                            _image4,
                                            width: 167.0,
                                            height: 111.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  90.0, 70.0, 0.0, 0.0),
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          "Save Images",
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
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonTheme(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
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
