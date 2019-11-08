import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';

class PrivilegePage extends StatefulWidget {
  @override
  State createState() => PrivilegePageState();
}

class PrivilegePageState extends State<PrivilegePage> {
  TextEditingController controller = new TextEditingController();
  Future<List<Privilege>> _getPrivileges() async {
    var data = await http
        .get("http://www.playnetworkafrica.com/public/api/privileges");

    var jsonData = json.decode(data.body);

    List<Privilege> privileges = [];

    for (var u in jsonData) {
      Privilege privilege = Privilege(
          u["pid"], u["desc"], u["name"], u["code"], u["image"], u["type"]);

      privileges.add(privilege);
    }

    print(privileges.length);

    return privileges;
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });

    _getPrivileges();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            'Privileges',
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
                MaterialPageRoute(builder: (context) => Navigation()),
              );
            },
          ),
          flexibleSpace: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 330,
                    height: 50,
                    child: TextField(
                      controller: searchController,
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
                ],
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(150.0),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _getPrivileges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.data);

          if (snapshot.data == null) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffc67608)),
                  ),
                ),
              ],
            ));
          } else {
            return Column(
              children: <Widget>[
                new Expanded(
                  child: Container(
                    child: RefreshIndicator(
                      onRefresh: _getPrivileges,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return filter == null || filter == ""
                                  ? Center(
                                      child: SafeArea(
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 5,
                                            ),
                                            RaisedButton(
                                              color: Colors.black,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrivilegeDetail(
                                                              snapshot.data[
                                                                  index])),
                                                );
                                              },
                                              child: Stack(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    child: new Image.network(
                                                      snapshot
                                                          .data[index].image,
                                                      gaplessPlayback: true,
                                                      width: 450,
                                                      height: 230,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(0.0,
                                                            225.0, 0.0, 0.0),
                                                    child: Center(
                                                      child: ButtonTheme(
                                                        minWidth: 80,
                                                        height: 30,
                                                        child: RaisedButton(
                                                          color:
                                                              Color(0xffc67608),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color: Color(
                                                                  0xffc67608),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  30.0),
                                                            ),
                                                          ),
                                                          child: Text(snapshot
                                                              .data[index]
                                                              .type),
                                                          textColor:
                                                              Colors.black,
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PrivilegeDetail(
                                                                          snapshot
                                                                              .data[index])),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(10.0,
                                                          280.0, 0.0, 0.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            snapshot.data[index]
                                                                .name,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : snapshot.data[index].name
                                          .toLowerCase()
                                          .contains(filter.toLowerCase())
                                      ? SingleChildScrollView(
                                          child: Center(
                                            child: SafeArea(
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.black,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PrivilegeDetail(
                                                                    snapshot.data[
                                                                        index])),
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          child:
                                                              new Image.network(
                                                            snapshot.data[index]
                                                                .image,
                                                            gaplessPlayback:
                                                                true,
                                                            width: 450,
                                                            height: 230,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0.0,
                                                                  225.0,
                                                                  0.0,
                                                                  0.0),
                                                          child: Center(
                                                            child: ButtonTheme(
                                                              minWidth: 80,
                                                              height: 30,
                                                              child:
                                                                  RaisedButton(
                                                                color: Color(
                                                                    0xffc67608),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xffc67608),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        30.0),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .type),
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                PrivilegeDetail(snapshot.data[index])),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10.0,
                                                                    280.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .name,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : new Container();
                            }),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
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

class PrivilegeDetail extends StatelessWidget {
  final Privilege privilege;

  PrivilegeDetail(this.privilege);

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  privilege.code,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'PLEASE DISPLAY THIS CODE TO AN APPROPIRATE STAFF TO APPLY YOUR DISCOUNT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          privilege.name,
          style: TextStyle(
            fontSize: 22,
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
              MaterialPageRoute(builder: (context) => PrivilegePage()),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: new Image.network(
                privilege.image,
                gaplessPlayback: true,
                width: 450,
                height: 230,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Text(
                          privilege.desc,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.black,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 0.0, 20.0, 0.0),
                              child: ButtonTheme(
                                minWidth: 350.0,
                                height: 60.0,
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
                                  child: Text("VIEW DISCOUNT"),
                                  textColor: Colors.white,
                                  onPressed: () => _showModalSheet(context),
                                ),
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
                Icons.people,
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

class Privilege {
  final int eid;
  final String desc;
  final String name;
  final String code;
  final String image;
  final String type;

  Privilege(this.eid, this.desc, this.name, this.code, this.image, this.type);
}
