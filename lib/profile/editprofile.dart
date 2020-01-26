import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_world/const.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';

class EditProfile extends StatefulWidget {
  @override
  State createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  TextEditingController controllerName;
  TextEditingController controllerAboutMe;
  TextEditingController controllerProfession;

  @override
  void initState() {
    super.initState();
    controllerName = new TextEditingController();
    controllerAboutMe = TextEditingController();
    controllerProfession = TextEditingController();
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

  final _formKey = GlobalKey<FormState>();
  final _professionKey = GlobalKey<FormState>();
  final _bioKey = GlobalKey<FormState>();

  String photoUrl = '';

  String _country;

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
      'country': _country,
    });

    Fluttertoast.showToast(
        msg: "Country Updated",
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

  Future<DocumentSnapshot> getUserDoc({bool useCache = true}) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    print('Loading Profile');

    var sameUser = await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot);

    return sameUser;
    //await needs to be placed here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        (avatarImageFile == null)
                            ? (photoUrl != ''
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
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Color(
                                                          0xffc67608), // border color
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        snapshot
                                                            .data['photoUrl'],
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
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        30.0, 20.0, 0.0, 0.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color(
                                                                  0xffc67608)),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                    ],
                                  ))
                            : Material(
                                child: Image.file(
                                  avatarImageFile,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(65.0, 65.0, 0.0, 0.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.add_box,
                            color: Color(0xffc67608),
                            size: 30,
                          ),
                          onPressed: getImage),
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
                    onPressed: uploadFile,
                    child: Text(
                      'Save Image',
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
              height: 30,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 250,
                            height: 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.black,
                                hintText: "Name",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffc67608))),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: controllerName,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 70,
                            height: 30,
                            child: RaisedButton(
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
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    final FirebaseUser user =
                                        await _auth.currentUser();
                                    final uid = user.uid;
                                    // here you write the codes to input the data into firestore
                                    Firestore.instance
                                        .collection('users')
                                        .document(uid)
                                        .updateData({
                                      'name': controllerName.text,
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: Text(
                                'save',
                                style: TextStyle(
                                  color: Color(0xffc67608),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 250,
                          height: 50,
                          decoration: UnderlineTabIndicator(
                              borderSide: BorderSide(
                            color: Color(0xffc67608),
                          )),
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                          child: new DropdownButton<String>(
                            iconEnabledColor: Colors.white,
                            value: _country,
                            hint: Text(
                              'Country',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                _country = newValue;
                              });
                            },
                            items: <String>[
                              'Australia',
                              'Austria',
                              'Argentina',
                              'Angola',
                              'Algeria',
                              'Bahamas',
                              'Bangladesh',
                              'Barbados',
                              'Belgium',
                              'Benin Republic',
                              'Brazil',
                              'Botswana',
                              'Bulgaria',
                              'Burkina Faso',
                              'Canada',
                              'Cameroon',
                              'Chile',
                              'China',
                              'Colombia',
                              'Congo',
                              'Costa Rica',
                              "Cote d'Ivoire",
                              'Croatia',
                              'Cyprus',
                              'Denmark',
                              'Ecuador',
                              'Egypt',
                              'Equatorial Guinea',
                              'Estonia',
                              'Ethopia',
                              'Finland',
                              'France',
                              'Gabon',
                              'Gambia',
                              'Germany',
                              'Ghana',
                              'Greece',
                              'Guatemala',
                              'Guinea',
                              'Haiti',
                              'Hungary',
                              'Iceland',
                              'India',
                              'Indonesia',
                              'Ireland',
                              'Israel',
                              'Italy',
                              'Jamaica',
                              'Japan',
                              'Jordan',
                              'Kenya',
                              'Kuwait',
                              'Lebanon',
                              'Liberia',
                              'Lithuania',
                              'Luxembourg',
                              'Madagascar',
                              'Malawi',
                              'Malaysia',
                              'Maldives',
                              'Mali',
                              'Mauritius',
                              'Mexico',
                              'Monaco',
                              'Morocco',
                              'Mozambique',
                              'Namibia',
                              'Nepal',
                              'Netherlands',
                              'New Zealand',
                              'Niger',
                              'Nigeria',
                              'Norway',
                              'Panama',
                              'Paraguay',
                              'Peru',
                              'Philippines',
                              'Poland',
                              'Portugal',
                              'Qatar',
                              'Romania',
                              'Russia',
                              'Rwanda',
                              'Senegal',
                              'Seychelles',
                              'Sierra Leone',
                              'Singapore',
                              'Slovakia',
                              'South Africa',
                              'South Korea',
                              'Spain',
                              'Sri Lanka',
                              'Sweden',
                              'Switzerland',
                              'Taiwan',
                              'Tanzania',
                              'Thailand',
                              'Togo',
                              'Turkey',
                              'Uganda',
                              'Ukraine',
                              'UAE',
                              'United Kingdom',
                              'United States of America',
                              'Uruguay',
                              'Venezuela',
                              'Zambia',
                              'Zimbabwe',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 70,
                          height: 30,
                          child: RaisedButton(
                            color: Colors.black,
                            onPressed: _updateCountry,
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
                              'save',
                              style: TextStyle(
                                color: Color(0xffc67608),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _professionKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 250,
                            height: 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.black,
                                hintText: "Profession",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffc67608))),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: controllerProfession,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Profession';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 70,
                            height: 30,
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color(0xffc67608),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              onPressed: () async {
                                if (_professionKey.currentState.validate()) {
                                  try {
                                    final FirebaseUser user =
                                        await _auth.currentUser();
                                    final uid = user.uid;
                                    // here you write the codes to input the data into firestore
                                    Firestore.instance
                                        .collection('users')
                                        .document(uid)
                                        .updateData({
                                      'profession': controllerProfession.text,
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: Text(
                                'save',
                                style: TextStyle(
                                  color: Color(0xffc67608),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _bioKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 250,
                            height: 50,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                fillColor: Colors.black,
                                hintText: "Bio",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffc67608))),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: controllerAboutMe,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Bio';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 70,
                            height: 30,
                            child: RaisedButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color(0xffc67608),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              onPressed: () async {
                                if (_bioKey.currentState.validate()) {
                                  try {
                                    final FirebaseUser user =
                                        await _auth.currentUser();
                                    final uid = user.uid;
                                    // here you write the codes to input the data into firestore
                                    Firestore.instance
                                        .collection('users')
                                        .document(uid)
                                        .updateData({
                                      'aboutMe': controllerAboutMe.text,
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: Text(
                                'save',
                                style: TextStyle(
                                  color: Color(0xffc67608),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
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