import 'package:flutter/material.dart';
import 'package:redbacks/views/home.dart';
import 'package:redbacks/views/login.dart';
import 'package:redbacks/views/signup.dart';

class Routes {
  // Route name constants
  static const String Login = '/login';
  static const String Signup = '/signup';
  static const String Home = '/home';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.Login: (context) => LoginView(),
      Routes.Signup: (context) => SignupView(),
      Routes.Home: (context) => HomeView(),
    };
  }
}
