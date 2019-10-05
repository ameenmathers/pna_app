import 'package:flutter/material.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/news/news1.dart';
import 'package:travel_world/news/news2.dart';
import 'package:travel_world/news/news3.dart';
import 'package:travel_world/news/news4.dart';
import 'package:travel_world/news/news5.dart';
import 'package:travel_world/profile/profile.dart';

class News extends StatefulWidget {
  final String currentUserId;

  News({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => NewsState(currentUserId: currentUserId);
}

class NewsState extends State<News> {
  NewsState({Key key, @required this.currentUserId});

  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News',
          style: TextStyle(
            fontSize: 30,
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
        child: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Play Network Africa',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                          ),
                          Text(
                            '27th Aug',
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
                              News1(currentUserId: currentUserId)),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/news1.jpeg'),
                        gaplessPlayback: true,
                      ),
                      Center(
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
                                        News1(currentUserId: currentUserId)),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Airport Lounge',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                            width: 120,
                          ),
                          Text(
                            '27th Aug',
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
                              News2(currentUserId: currentUserId)),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/news2.jpeg'),
                        gaplessPlayback: true,
                      ),
                      Center(
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
                                        News2(currentUserId: currentUserId)),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Tax Master',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
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
                            width: 120,
                          ),
                          Text(
                            '29th Aug',
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
                              News3(currentUserId: currentUserId)),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/news3.jpeg'),
                        gaplessPlayback: true,
                      ),
                      Center(
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
                                        News3(currentUserId: currentUserId)),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Play Network',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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
                            width: 120,
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
                              News4(currentUserId: currentUserId)),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/news4.jpeg'),
                        gaplessPlayback: true,
                      ),
                      Center(
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
                                        News4(currentUserId: currentUserId)),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Play Network',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Play Network Africa',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 120,
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
                              News5(currentUserId: currentUserId)),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/news5.jpeg'),
                        gaplessPlayback: true,
                      ),
                      Center(
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
                                        News5(currentUserId: currentUserId)),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'Sprinster Festival',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                      builder: (context) =>
                          Meetup(currentUserId: currentUserId)),
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
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ChatScreen()),
//                );
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
                      builder: (context) => Profile(
                            currentUserId: currentUserId,
                          )),
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
