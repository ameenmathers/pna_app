import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:travel_world/form/form1.dart';
import 'package:travel_world/navigation/navigation.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Center(
                child: new Image.asset(
                  'images/ban7.png',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
                  gaplessPlayback: true,
                ),
              ),
              Container(
                color: Colors.transparent,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Form1()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "PLAY NETWORK AFRICA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.none,
                            fontFamily: 'SFProDisplay',
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 32.0, 16.0),
                            child: TextField(
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orangeAccent)),
                                labelText: 'Email Address',
                                filled: true,
                                fillColor: Colors.black,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orangeAccent)),
                                focusColor: Colors.black,
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 32.0, 16.0),
                            child: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.black,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orangeAccent)),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
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
                              child: Text("Sign In"),
                              textColor: Colors.white,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });

                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  if (user != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Navigation()),
                                    );
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }
                                } catch (e) {
                                  authProblems errorType;
                                  if (Platform.isAndroid) {
                                    switch (e.message) {
                                      case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                                        errorType = authProblems.UserNotFound;
                                        break;
                                      case 'The password is invalid or the user does not have a password.':
                                        errorType =
                                            authProblems.PasswordNotValid;
                                        break;
                                      case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                                        errorType = authProblems.NetworkError;
                                        break;
                                      // ...
                                      default:
                                        print(
                                            'Case ${e.message} is not yet implemented');
                                    }
                                  } else if (Platform.isIOS) {
                                    switch (e.code) {
                                      case 'Error 17011':
                                        errorType = authProblems.UserNotFound;
                                        break;
                                      case 'Error 17009':
                                        errorType =
                                            authProblems.PasswordNotValid;
                                        break;
                                      case 'Error 17020':
                                        errorType = authProblems.NetworkError;
                                        break;
                                      // ...
                                      default:
                                        print(
                                            'Case ${e.message} is not yet implemented');
                                    }
                                  }

                                  setState(() {
                                    showSpinner = false;
                                  });
                                  print('The error is $errorType');
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.center,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
