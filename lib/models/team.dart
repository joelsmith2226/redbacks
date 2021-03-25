import 'package:redbacks/models/player.dart';

class Team {
  List<Player> players;

  Team.blank() {
    this.players = [
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
    ];
  }
}
