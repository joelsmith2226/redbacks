import 'package:flutter/material.dart';
import 'package:redbacks/views/admin.dart';
import 'package:redbacks/views/choose_team.dart';
import 'package:redbacks/views/confirm_transfer.dart';
import 'package:redbacks/views/edit_gw.dart';
import 'package:redbacks/views/flag.dart';
import 'package:redbacks/views/home.dart';
import 'package:redbacks/views/loading.dart';
import 'package:redbacks/views/login.dart';
import 'package:redbacks/views/player_stats.dart';
import 'package:redbacks/views/point_page_other_user.dart';
import 'package:redbacks/views/settings.dart';
import 'package:redbacks/views/signup.dart';
import 'package:redbacks/views/unknown.dart';
import 'package:redbacks/views/user.dart';

class Routes {
  // Route name constants
  static const String Login = '/login';
  static const String Signup = '/signup';
  static const String ChooseTeam = '/choose-team';
  static const String Home = '/home';
  static const String Loading = '/loading';
  static const String Admin = '/admin';
  static const String Flag = '/admin/flag';
  static const String EditGW = '/admin/edit-gw';
  static const String PlayerStats = '/player-stats';
  static const String PointPageOther = '/home/point-page-other-user';
  static const String Unknown = '/unknown';
  static const String Confirm = '/choose-team/confirm-transfer';
  static const String Settings = '/settings';
  static const String User = '/user';


  /// The map used to define our routes, needs to be supplied to [MaterialApp]
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      Routes.Login: (context) => LoginView(),
      Routes.Signup: (context) => SignupView(),
      Routes.Home: (context) => HomeView(),
      Routes.ChooseTeam: (context) => ChooseTeamView(),
      Routes.Loading: (context) => LoadingView(),
      Routes.Admin: (context) => AdminView(),
      Routes.PlayerStats: (context) => PlayerStatsView(),
      Routes.PointPageOther: (context) => PointPageOtherUser(),
      Routes.EditGW: (context) => EditGWView(),
      Routes.Unknown: (context) => UnknownView(),
      Routes.Flag: (context) => FlagView(),
      Routes.Confirm: (context) => ConfirmTransfersView(),
      Routes.Settings: (context) => SettingsView(),
      Routes.User: (context) => UserView(),
    };
  }
}
