import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redbacks/app_config.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/theme_switcher.dart';
import 'package:redbacks/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  var configuredApp = new AppConfig(
    flavorName: 'prod',
    child: new ThemeSwitcherWidget(
      initialTheme: _themes[themeChoice],
      child: MyApp(Firebase.initializeApp(), FirebaseAuth.instance),
    ),
  );

  runApp(configuredApp);
}
