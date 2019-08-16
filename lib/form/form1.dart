import 'package:flutter/material.dart';
import 'package:travel_world/formsec/form2.dart';

class Form1 extends StatefulWidget {
  @override
  _Form1State createState() => _Form1State();
}

class _Form1State extends State<Form1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage("images/ban4.png"),
            ),
            Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "PLAY NETWORK AFRICA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 0.0, 20.0, 0.0),
                        child: Text(
                          "To apply or log in, use your phone number",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Select country',
                            fillColor: Colors.grey.shade700,
                            focusedBorder: InputBorder.none,
                            filled: true,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusColor: Colors.white,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                            focusedBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade700,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusColor: Colors.white,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Reasons for joining PNA',
                            focusedBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade700,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusColor: Colors.white,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                        child: ButtonTheme(
                          minWidth: 350.0,
                          height: 60.0,
                          child: RaisedButton(
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.amber,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Text("Next"),
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Form2()),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Text(
                          "By clicking sign up you agree to the following",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 10.0),
                        child: Text(
                          'Terms and Conditions without reservation',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
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
    );
  }
}
