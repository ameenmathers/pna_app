import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var url = 'http://localhost:8000/api/events';
  var events = "empty";

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
      body: Center(
        child: Column(
          children: <Widget>[
            Text(this.events),
            IconButton(
                icon: Icon(Icons.message),
                onPressed: () async {
                  var response = await http.get(this.url);
                  var decodedData = json.decode(response.body);

                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');

                  setState(() {
                    this.events = decodedData['message'];
                    this.events = decodedData['body'];
                  });
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orangeAccent,
            icon: Icon(Icons.near_me),
            title: Text(''),
          ),
        ],
      ),
    );
  }
}
