import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:travel_world/meetup/meetup.dart';
import 'package:travel_world/messages/messages.dart';
import 'package:travel_world/navigation/navigation.dart';
import 'package:travel_world/profile/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => new _EventsState();
}

class _EventsState extends State<Events> {
  Future<List<Event>> _getEvents({bool useCache = true}) async {
    print('Loading events');

    String data;

    /// Do we have a cache we can use?
    var cache = await cacheExists();

    /// If the cache exists and it contains data use that, otherwise we call the API
    if (cache && useCache) {
      print('We have cached data');

      data = await readToFile();
    } else {
      print('No cache. Fetching from API');

      var apiData =
          await http.get("http://www.playnetworkafrica.com/public/api/events");

      data = apiData.body;

      /// Now save the fetched data to the cache
      await writeToFile(data);
    }

    var jsonData = json.decode(data);

    List<Event> events = [];

    for (var u in jsonData.reversed) {
      Event event = Event(u["eid"], u["desc"], u["rsvpurl"], u["name"],
          u["location"], u["image"], u["type"], u["paymenturl"], u["date"]);

      events.add(event);
    }

    print(events.length);

    return events;
  }

  Future<List<Event>> _refreshEvents({bool useCache = true}) async {
    print('Loading events');

    String data;

    /// Do we have a cache we can use?
    var cache = await cacheExists();

    /// If the cache exists and it contains data use that, otherwise we call the API
    if (cache && useCache) {
      print('We have cached data');

      var apiData =
          await http.get("http://www.playnetworkafrica.com/public/api/events");

      data = apiData.body;

      /// Now save the fetched data to the cache
      await writeToFile(data);
    }

    var jsonData = json.decode(data);

    List<Event> events = [];

    for (var u in jsonData.reversed) {
      Event event = Event(u["eid"], u["desc"], u["rsvpurl"], u["name"],
          u["location"], u["image"], u["type"], u["paymenturl"], u["date"]);

      events.add(event);
    }

    print(events.length);

    return events;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get myfile async {
    final path = await _localPath;
    return File('$path/file.txt');
  }

  static Future<bool> cacheExists() async {
    var file = await myfile;

    return file.exists();
  }

  static writeToFile(jsonData) async {
    final file = await myfile;
    file.writeAsString(jsonData);
  }

  static readToFile() async {
    try {
      final file = await myfile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {}
  }

  var myFile = new File('file.txt');

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

    _getEvents();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            'EVENTS',
            style: TextStyle(
              fontSize: 20,
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
                MaterialPageRoute(builder: (context) => Navigation()),
              );
            },
          ),
          flexibleSpace: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                width: 350,
                height: 50,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(140.0),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _getEvents(),
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
            return Container(
              child: RefreshIndicator(
                onRefresh: _refreshEvents,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: filter == null || filter == ""
                          ? SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40.0, 0.0, 40.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].name
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index].date
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                            builder: (context) => EventDetail(
                                                snapshot.data[index])),
                                      );
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                snapshot.data[index].image,
                                            width: 450,
                                            height: 230,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 245.0, 0.0, 0.0),
                                              child: Text(
                                                snapshot.data[index].location
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Color(0xffc67608),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20.0, 190.0, 0.0, 0.0),
                                              child: Center(
                                                child: ButtonTheme(
                                                  minWidth: 80,
                                                  height: 30,
                                                  child: RaisedButton(
                                                    color: Color(0xffc67608),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color:
                                                            Color(0xffc67608),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
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
                                                                EventDetail(
                                                                    snapshot.data[
                                                                        index])),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 245.0, 0.0, 0.0),
                                              child: Text(
                                                snapshot.data[index].type
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Color(0xffc67608),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          : snapshot.data[index].name
                                  .toLowerCase()
                                  .contains(filter.toLowerCase())
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 0.0),
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
                                                  width: 200,
                                                ),
                                                Text(
                                                  snapshot.data[index].date,
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
                                                    EventDetail(
                                                        snapshot.data[index])),
                                          );
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    snapshot.data[index].image,
                                                width: 450,
                                                height: 230,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 245.0, 0.0, 0.0),
                                                  child: Text(
                                                    snapshot
                                                        .data[index].location
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Color(0xffc67608),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20.0, 190.0, 0.0, 0.0),
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
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                40.0),
                                                          ),
                                                        ),
                                                        child:
                                                            Text("Read More"),
                                                        textColor: Colors.black,
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    EventDetail(
                                                                        snapshot
                                                                            .data[index])),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 245.0, 0.0, 0.0),
                                                  child: Text(
                                                    snapshot.data[index].type
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Color(0xffc67608),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : new Container(),
                    );
                  },
                ),
              ),
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
                Icons.perm_identity,
                color: Colors.grey,
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

class EventDetail extends StatelessWidget {
  final Event event;

  EventDetail(this.event);

  _launchURL() async {
    final url = event.paymenturl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _rsvpURL() async {
    final url = event.rsvpurl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
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
              MaterialPageRoute(builder: (context) => Events()),
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
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {},
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: event.image,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: Text(
                              event.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                            child: Text(
                              event.date,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Center(
                          child: Text(
                            event.desc,
                            textAlign: TextAlign.justify,
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
                  height: 25,
                ),
                Center(
                  child: (event.paymenturl == null)
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Center(
                            child: ButtonTheme(
                              minWidth: 200,
                              height: 50,
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
                                child: Text("RSVP"),
                                textColor: Colors.black,
                                onPressed: _rsvpURL,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Center(
                            child: ButtonTheme(
                              minWidth: 200,
                              height: 50,
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
                                child: Text("Buy Ticket"),
                                textColor: Colors.black,
                                onPressed: _launchURL,
                              ),
                            ),
                          ),
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
                Icons.perm_identity,
                color: Colors.grey,
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

class Event {
  final int eid;
  final String desc;
  final String rsvpurl;
  final String name;
  final String location;
  final String image;
  final String type;
  final String paymenturl;
  final String date;

  Event(this.eid, this.desc, this.rsvpurl, this.name, this.location, this.image,
      this.type, this.paymenturl, this.date);
}
