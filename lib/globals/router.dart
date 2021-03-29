import 'package:flutter/material.dart';
import 'package:redbacks/views/choose_team.dart';
import 'package:redbacks/views/home.dart';
import 'package:redbacks/views/login.dart';
import 'package:redbacks/views/signup.dart';
import 'package:redbacks/views/transfer.dart';

class Routes {
  // Route name constants
  static const String Login = '/login';
  static const String Signup = '/signup';
  static const String ChooseTeam = '/choose-team';
  static const String Home = '/home';
  static const String Transfer = '/transfer';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.Login: (context) => LoginView(),
      Routes.Signup: (context) => SignupView(),
      Routes.Home: (context) => HomeView(),
      Routes.ChooseTeam: (context) => ChooseTeamView(),
      Routes.Transfer: (context) => TransferView(),
    };
  }
}
