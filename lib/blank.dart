import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlankPage extends StatefulWidget {
  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  final String url = 'http://localhost:8000/api/events';
  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJsonData();
  }

  Future<Event> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    print(response.body);

    setState(() {
      var decodedData = json.decode(response.body);
      data = decodedData['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(data[index])),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Image.network(data[index]['image']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
                            child: Text(
                              data[index]['name'],
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
                                              EventPage(data[index])),
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
                            data[index]['desc'],
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class EventPage extends StatelessWidget {
  final Event event;

  EventPage(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(event.name),
    ));
  }
}

class Event {
  final String name;
  final String location;
  final String date;
  final String desc;
  final String paymenturl;
  final String image;

  Event(this.name, this.location, this.date, this.desc, this.paymenturl,
      this.image);

  factory Event.fromJson(Map<String, dynamic> data) {
    Map<String, dynamic> map = Map<String, dynamic>.from(data);
    return Event(map['name'], map['location'], map['date'], map['desc'],
        map['payment'], map['image']);
  }
}
