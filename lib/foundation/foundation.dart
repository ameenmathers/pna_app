import 'package:flutter/material.dart';
import 'package:travel_world/chat/chat.dart';
import 'package:travel_world/foundation/foundation1.dart';
import 'package:travel_world/foundation/foundation2.dart';
import 'package:travel_world/foundation/foundation3.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class Foundation extends StatefulWidget {
  final String currentUserId;

  Foundation({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => FoundationState(currentUserId: currentUserId);
}

class FoundationState extends State<Foundation> {
  FoundationState({Key key, @required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Foundation',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Foundation1(
                                currentUserId: currentUserId,
                              )),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/sudan.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                                      builder: (context) => Foundation1(
                                            currentUserId: currentUserId,
                                          )),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 180.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('images/icons8.png'),
                                  gaplessPlayback: true,
                                  width: 30,
                                  height: 40,
                                ),
                                Text(
                                  'Sponsor a child',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '12 Jan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 230, 0.0, 0.0),
                        child: Text(
                          'Sponsor a child to school for a year',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/found1.png'),
                      gaplessPlayback: true,
                      width: 170,
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        gaplessPlayback: true,
                        image: AssetImage('images/sudan1.png'),
                        width: 170,
                        height: 120,
                      ),
                    )
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: ButtonTheme(
                        minWidth: 50,
                        height: 25,
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
                          child: Text("Foundations"),
                          textColor: Colors.black,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 65,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Foundation2(
                                currentUserId: currentUserId,
                              )),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/found2.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                                      builder: (context) => Foundation2(
                                            currentUserId: currentUserId,
                                          )),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 180.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('images/icons8.png'),
                                  gaplessPlayback: true,
                                  width: 30,
                                  height: 40,
                                ),
                                Text(
                                  'Tiny Beating Hearts Initiative',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '12 Jan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 230, 0.0, 0.0),
                        child: Text(
                          'Support the training of staff to take care of preterm babies',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/baby.png'),
                      gaplessPlayback: true,
                      width: 170,
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: AssetImage('images/sudan2.png'),
                        gaplessPlayback: true,
                        width: 170,
                        height: 120,
                      ),
                    )
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
                SizedBox(
                  height: 65,
                ),
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Foundation3(
                                currentUserId: currentUserId,
                              )),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/volunteers1.png'),
                        gaplessPlayback: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
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
                                      builder: (context) => Foundation3(
                                            currentUserId: currentUserId,
                                          )),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 180.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('images/icons8.png'),
                                  gaplessPlayback: true,
                                  width: 30,
                                  height: 40,
                                ),
                                Text(
                                  'Red Cross Of Nigeria',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '12 Jan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 230, 0.0, 0.0),
                        child: Text(
                          'Support Food and health aid to undernourished populations in India',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/cross1.png'),
                      gaplessPlayback: true,
                      width: 170,
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Image(
                        image: AssetImage('images/cross2.png'),
                        gaplessPlayback: true,
                        width: 170,
                        height: 120,
                      ),
                    )
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
                  MaterialPageRoute(builder: (context) => Chat()),
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
