import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redbacks/providers/logged_in_user.dart';

import 'package:redbacks/views/login.dart';
import 'package:redbacks/views/unknown.dart';

import 'globals/constants.dart';
import 'globals/initial_data.dart';
import 'globals/router.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // declaring twice..?
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;

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
          // InitialData(); ..todo review this
          return ChangeNotifierProvider(
              create: (context) => LoggedInUser(),
              child:  RefreshConfiguration(
                // headerBuilder: () => WaterDropHeader(),
                // footerBuilder:  () => ClassicFooter(),
                headerTriggerDistance: 80.0,
                springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
                maxOverScrollExtent :100,
                maxUnderScrollExtent:0,
                enableScrollWhenRefreshCompleted: true,
                enableLoadingWhenFailed : true,
                hideFooterWhenNotFull: false,
                enableBallisticLoad: true,
                child: LaunchApp(),
              ),
          );
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
        primaryColor: Color(0xFFa01300),
        accentColor:  Color(0xFFa01300).withAlpha(150),
        textTheme: GoogleFonts.merriweatherSansTextTheme()
      ),
      home: LoginView(),
      routes: Routes.getRoutes(),
      onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => UnknownView()),
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
    print("loading..");
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text("Loading"),
        ),
      ),
    );
  }
}
