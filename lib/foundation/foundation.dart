import 'package:flutter/material.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/notifications/notifications.dart';
import 'package:travel_world/profile/profile.dart';

class Foundation extends StatefulWidget {
  @override
  _FoundationState createState() => _FoundationState();
}

class _FoundationState extends State<Foundation> {
  var url = 'http://localhost:8000/api/events';
  var events = "empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Navigation()),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 0.0, 0.0),
                      child: Text(
                        'Foundation',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 33,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: null),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                      color: Colors.white,
                    )),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Support Foundation',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Show all',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_right,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: null),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      height: 180,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view.png',
                              width: 200,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 90.0, 60.0, 0.0),
                                child: Text("T.A.F",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                      height: 180,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view2.png',
                              width: 200,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 90.0, 30.0, 0.0),
                                child: Text("Sudan",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 15.0, 0.0),
                                child: Text("1370 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
                      height: 180,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view3.png',
                              width: 200,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 90.0, 10.0, 0.0),
                                child: Text("Red Cross",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
                      height: 170,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view4.png',
                              width: 200,
                              height: 170,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 90.0, 60.0, 0.0),
                                child: Text("TBHI",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      height: 180,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view5.png',
                              width: 200,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 110.0, 20.0, 0.0),
                                child: Text("PIFFHB",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Pictures",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      height: 180,
                      width: 200,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: new Image.asset(
                              'images/view6.png',
                              width: 200,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 110.0, 10.0, 0.0),
                                child: Text("PFS Fund",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 15.0, 0.0),
                                child: Text("1639 Articles",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Navigation()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.comment,
                color: Colors.white,
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
                Icons.people,
                color: Colors.white,
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
                Icons.near_me,
                color: Colors.orangeAccent,
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
