import 'package:flutter/material.dart';
import 'package:redbacks/views/login.dart';

import 'globals/constants.dart';
import 'globals/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFa01300, colorSwatch),
      ),
      home: LoginView(),
      routes: Routes.getRoutes(),
    );
  }
}
