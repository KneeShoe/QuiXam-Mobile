import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'LoginPage.dart';
import 'SomethingWentWrong.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {return new MaterialApp(
      title: "QuiXam",
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new SomethingWentWrong()
    );
      return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return new MaterialApp(
        title: "QuiXam",
        theme: new ThemeData(
          primaryColor: Colors.blue,
        ),
        home: new SomethingWentWrong()
      );
    }

    return new MaterialApp(
      title: "QuiXam",
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}
