import 'package:redbacks/models/team.dart';
import 'package:redbacks/providers/gameweek.dart';

class UserGW {
  Team team;
  Gameweek gw;
  int points;

  UserGW({this.team, this.gw, this.points});
}