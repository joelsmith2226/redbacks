import 'package:flutter/material.dart';
import 'package:redbacks/views/admin.dart';
import 'package:redbacks/views/choose_team.dart';
import 'package:redbacks/views/edit_gw.dart';
import 'package:redbacks/views/home.dart';
import 'package:redbacks/views/loading.dart';
import 'package:redbacks/views/login.dart';
import 'package:redbacks/views/player_stats.dart';
import 'package:redbacks/views/point_page_other_user.dart';
import 'package:redbacks/views/signup.dart';
import 'package:redbacks/views/transfer.dart';

class Routes {
  // Route name constants
  static const String Login = '/login';
  static const String Signup = '/signup';
  static const String ChooseTeam = '/choose-team';
  static const String Home = '/home';
  static const String Transfer = '/transfer';
  static const String Loading = '/loading';
  static const String Admin = '/admin';
  static const String EditGW = '/admin/edit-gw';
  static const String PlayerStats = '/player-stats';
  static const String PointPageOther = '/home/point-page-other-user';

  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.Login: (context) => LoginView(),
      Routes.Signup: (context) => SignupView(),
      Routes.Home: (context) => HomeView(),
      Routes.ChooseTeam: (context) => ChooseTeamView(),
      Routes.Transfer: (context) => TransferView(),
      Routes.Loading: (context) => LoadingView(),
      Routes.Admin: (context) => AdminView(),
      Routes.PlayerStats: (context) => PlayerStatsView(),
      Routes.PointPageOther: (context) => PointPageOtherUser(),
      Routes.EditGW: (context) => EditGWView(),
    };
  }
}
