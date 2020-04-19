import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:photo_view/photo_view.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/const.dart';
import 'package:travel_world/full_screen_image.dart';
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
      if (!blockedUsers.contains(element.data['uid']) == null) {
        return !blockedUsers.contains(element.data['uid'] == null);
      } else {
        return !blockedUsers.contains(element.data['uid']);
      }
    }).toList();

    setState(() {
      _sameCountryUsersDocumentSnapshotList = correctUsersList;
    });
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
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAppBar(),
          _buildSearchBar(),
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
                color: Color(0xffc67608),
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                Icons.perm_identity,
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                    email: userDataMap['email'],
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
          height: 20.0,
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
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      centerTitle: true,
    );
  }
}

class ViewProfile extends StatefulWidget {
  String name;
  String email;
  String country;
  String aboutMe;
  String profession;
  String gender;
  String photoUrl;
  final List images;
  String uid;

  ViewProfile(
      {this.name,
      this.email,
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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  PhotoViewScaleStateController scaleStateController;

  main() async {
    String username = 'ameenidris710@gmail.com';
    String password = 'allahu710';

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('alameenidris710@gmail.com') //recipent email
      ..subject = 'User Reported ${DateTime.now()}' //subject of the email
      ..text =
          'The user ${widget.name} from  ${widget.country} has been reported.\n The user has violated a rule will be under review'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }

    Fluttertoast.showToast(
        msg: "User reported and will be under review",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 13.0);
  }

  String key1 = '';

  Future blockUser() async {
    final FirebaseUser user = await firebaseAuth.currentUser();
    final uid = user.uid;

    key1 = '${widget.uid}';

    Firestore.instance.collection('users').document(uid).updateData({
      'blockedUsers': FieldValue.arrayUnion([key1])
    });

    Fluttertoast.showToast(
        msg: "User Blocked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 14.0);
  }

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
                    ),
                    SizedBox(
                      width: 15,
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
                      onPressed: main,
                      child: Text(
                        'Report',
                        style: TextStyle(
                          color: Color(0xffc67608),
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
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
                      onPressed: blockUser,
                      child: Text(
                        'Block ${widget.name}',
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
                                    name: widget.name,
                                    country: widget.country,
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
                color: Color(0xffc67608),
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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
                Icons.perm_identity,
                color: Colors.grey,
              ),
              splashColor: Colors.white,
              highlightColor: Colors.amber,
              enableFeedback: true,
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

class ProfileImageItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String country;

  const ProfileImageItem({
    Key key,
    @required this.imageUrl,
    this.name,
    this.country,
  }) : super(key: key);

  flag() async {
    String username = 'ameenidris710@gmail.com';
    String password = 'allahu710';

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('alameenidris710@gmail.com') //recipent email
      ..subject = 'User Post Flagged ${DateTime.now()}' //subject of the email
      ..text =
          'A post from user ${name} from  ${country} hsd been flagged.\n The user has violated a rule will be under review'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }

    Fluttertoast.showToast(
        msg: "Post was flagged",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Color(0xffc67608),
        textColor: Colors.white,
        fontSize: 13.0);
  }

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
              onTap: flag,
              child: Icon(
                Icons.flag,
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
