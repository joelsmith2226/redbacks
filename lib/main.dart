import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redbacks/globals/theme_switcher.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:redbacks/views/login.dart';
import 'package:redbacks/views/root.dart';
import 'package:redbacks/views/unknown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'globals/constants.dart';
import 'globals/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Removes landscape option
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(); // declaring twice..?
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Color primaryColor = Color(prefs.get('primaryColor') ?? 0xffa01300);
  int themeChoice = prefs.get('theme') ?? LIGHT_THEME;
  var _themes = {
    LIGHT_THEME: ThemeData(
        primarySwatch: MaterialColor(0xFFa01300, colorSwatch),
        primaryColor: primaryColor,
        accentColor: primaryColor.withAlpha(150),
        textTheme: GoogleFonts.merriweatherSansTextTheme()),
    DARK_THEME: ThemeData.dark(),
  };

  runApp(
    ThemeSwitcherWidget(
      initialTheme: _themes[themeChoice],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
          return ChangeNotifierProvider(
            create: (context) => LoggedInUser(),
            child: RefreshConfiguration(
              headerTriggerDistance: 80.0,
              springDescription:
                  SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
              maxOverScrollExtent: 100,
              maxUnderScrollExtent: 0,
              enableScrollWhenRefreshCompleted: true,
              enableLoadingWhenFailed: true,
              hideFooterWhenNotFull: false,
              enableBallisticLoad: true,
              child: LaunchApp(context),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }

  Widget LaunchApp(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Sizer(builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Redbacks Fantasy League',
          theme: ThemeSwitcher.of(context).themeData,
          home: RootView(),
          routes: Routes.getRoutes(),
          onUnknownRoute: (settings) =>
              MaterialPageRoute(builder: (context) => UnknownView()),
        );
      }),
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
