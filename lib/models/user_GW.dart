import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/transfer.dart';
import 'package:redbacks/providers/gameweek.dart';

/// Stores historical data of a user's state at this point in time
class UserGW {
  Team team;
  Gameweek gw;
  int points;
  int hits;
  String chip;
  int totalPts;
  List<Transfer> completedTransfers = [];


  UserGW({this.team, this.gw, this.points, this.hits, this.completedTransfers, this.chip, this.totalPts});
}