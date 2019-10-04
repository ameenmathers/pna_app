import 'package:flutter/material.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/event/event2.dart';
import 'package:travel_world/event/event3.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Events extends StatefulWidget {
  final String currentUserId;

  Events({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => EventsState(currentUserId: currentUserId);
}

class EventsState extends State<Events> {
  EventsState({Key key, @required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EVENTS',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Navigation(
                        currentUserId: currentUserId,
                      )),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: 330,
              height: 50,
              child: TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                    labelText: "Search",
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            SizedBox(
              height: 40,
            ),
//            Row(
//              children: <Widget>[
//                SizedBox(
//                  width: 30,
//                ),
////                Padding(
////                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
////                  child: Row(
////                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                    children: <Widget>[
////                      Text(
////                        'Play Network Africa',
////                        style: TextStyle(
////                          fontSize: 17,
////                          color: Colors.white,
////                        ),
////                      ),
////                      SizedBox(
////                        width: 100,
////                      ),
////                      Text(
////                        '',
////                        style: TextStyle(
////                          fontSize: 14,
////                          color: Colors.white,
////                        ),
////                      ),
////                    ],
////                  ),
////                ),
//              ],
//            ),
//            SizedBox(
//              height: 20,
//            ),
//            RaisedButton(
//              color: Colors.black,
//              onPressed: () {},
//              child: Stack(
//                children: <Widget>[
//                  Image(
//                    image: Image(''),
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
//                        child: Text(
//                          '',
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.fromLTRB(0.0, 270.0, 0.0, 0.0),
//                        child: Center(
//                          child: ButtonTheme(
//                            minWidth: 80,
//                            height: 30,
//                            child: RaisedButton(
//                              color: Color(0xffc67608),
//                              shape: RoundedRectangleBorder(
//                                side: BorderSide(
//                                  color: Color(0xffc67608),
//                                ),
//                                borderRadius: BorderRadius.all(
//                                  Radius.circular(40.0),
//                                ),
//                              ),
//                              child: Text("Read More"),
//                              textColor: Colors.black,
//                              onPressed: () {},
//                            ),
//                          ),
//                        ),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
//                        child: Text(
//                          "CONCERT",
//                          style: TextStyle(
//                            color: Color(0xffc67608),
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(10.0, 340, 0.0, 0.0),
//                    child: Center(
//                      child: Text(
//                        '',
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 15,
//                          fontWeight: FontWeight.w200,
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Play Network Africa',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        '28th Aug',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Event2(currentUserId: currentUserId)),
                );
              },
              child: Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage('images/wiz.png'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                        child: Text(
                          "ABUJA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 270.0, 0.0, 0.0),
                        child: Center(
                          child: ButtonTheme(
                            minWidth: 80,
                            height: 30,
                            child: RaisedButton(
                              color: Color(0xffc67608),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xffc67608),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                              ),
                              child: Text("Read More"),
                              textColor: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Event2(currentUserId: currentUserId)),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                        child: Text(
                          "CONCERT",
                          style: TextStyle(
                            color: Color(0xffc67608),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 340, 0.0, 0.0),
                    child: Center(
                      child: Text(
                        'Updates on past networking events, upcoming events and other play network events.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Play Network Africa',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        '30th Aug',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Event3(currentUserId: currentUserId)),
                );
              },
              child: Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage('images/baba.png'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                        child: Text(
                          "ABUJA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 270.0, 0.0, 0.0),
                        child: Center(
                          child: ButtonTheme(
                            minWidth: 80,
                            height: 30,
                            child: RaisedButton(
                              color: Color(0xffc67608),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xffc67608),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40.0),
                                ),
                              ),
                              child: Text("Read More"),
                              textColor: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Event3(currentUserId: currentUserId)),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                        child: Text(
                          "CONCERT",
                          style: TextStyle(
                            color: Color(0xffc67608),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 340, 0.0, 0.0),
                    child: Center(
                      child: Text(
                        'Updates on past networking events, upcoming events and other play network events.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ],
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
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navigation(
                            currentUserId: currentUserId,
                          )),
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
                  MaterialPageRoute(
                      builder: (context) => Meetup(
                            currentUserId: currentUserId,
                          )),
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
                  MaterialPageRoute(builder: (context) => ChatScreen()),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Profile(currentUserId: currentUserId)),
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
