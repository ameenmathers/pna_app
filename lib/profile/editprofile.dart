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
  final String name;
  final String country;
  final String profession;
  final String bio;

  const EditProfile({
    Key key,
    @required this.name,
    @required this.country,
    @required this.profession,
    @required this.bio,
  }) : super(key: key);
  @override
  State createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  TextEditingController controllerName;
  TextEditingController controllerAboutMe;
  TextEditingController controllerProfession;

  bool _countryDropdownHasErrors = false;

  @override
  void initState() {
    super.initState();
    controllerName = new TextEditingController()..text = widget.name;
    controllerAboutMe = TextEditingController()..text = widget.bio;
    controllerProfession = TextEditingController()..text = widget.profession;
    _country = widget.country;
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
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
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
                                              imageUrl: photoUrl,
                                              width: 100.0,
                                              height: 90.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(45.0)),
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
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            decoration:
                                                                new BoxDecoration(
                                                              color: Color(
                                                                  0xffc67608), // border color
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  CachedNetworkImageProvider(
                                                                snapshot.data[
                                                                    'photoUrl'],
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    30.0,
                                                                    20.0,
                                                                    0.0,
                                                                    0.0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(45.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  65.0, 65.0, 0.0, 0.0),
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
                            Container(
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
                              height: 20,
                            ),
                            FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.black,
                                  ),
                                  child: new DropdownButtonFormField<String>(
                                    value: _country,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.black,
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      focusColor: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffc67608))),
                                    ),
                                    validator: (String newValue) {
                                      if (newValue == null) {
                                        return 'Please enter country';
                                      }
                                      return null;
                                    },
                                    hint: Text(
                                      'Country',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
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
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
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
                              height: 20,
                            ),
                            Container(
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
                              height: 20,
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
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      final FirebaseUser user =
                                          await _auth.currentUser();
                                      final uid = user.uid;

                                      var batch = Firestore.instance.batch();

                                      batch.updateData(
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid),
                                          {
                                            'name': controllerName.text,
                                          });
                                      batch.updateData(
                                          Firestore.instance
                                              .collection('users')
                                              .document(uid),
                                          {
                                            'country': _country,
                                            'name': controllerName.text,
                                            'profession':
                                                controllerProfession.text,
                                            'aboutMe': controllerAboutMe.text,
                                          });

                                      await batch.commit();

                                      setState(() {
                                        isLoading = false;
                                      });

                                      Fluttertoast.showToast(
                                          msg: "Profile Saved Succesfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIos: 1,
                                          backgroundColor: Color(0xffc67608),
                                          textColor: Colors.white,
                                          fontSize: 14.0);

                                      Navigator.pop(context);
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Something went wrong",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIos: 1,
                                          backgroundColor: Color(0xffc67608),
                                          textColor: Colors.white,
                                          fontSize: 14.0);

                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Text(
                                  'save',
                                  style: TextStyle(
                                    color: Color(0xffc67608),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
