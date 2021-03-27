import 'package:flutter/material.dart';
import 'package:redbacks/views/login.dart';

import 'globals/constants.dart';
import 'globals/router.dart';

import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("Connected successfully to Firebase");
          return LaunchApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }

  Widget LaunchApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFa01300, colorSwatch),
      ),
      home: LoginView(),
      routes: Routes.getRoutes(),
    );
  }

  Widget SomethingWentWrong() {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text("Something went wrong. Sorry big fella. Restart?"),
        ),
      ),
    );
  }

  Widget Loading() {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text("Loading"),
        ),
      ),
    );
  }
}
