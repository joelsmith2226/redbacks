import 'package:redbacks/models/player.dart';

class Team {
  List<Player> _players;

  Team.blank() {
    this._players = [
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
      Player.blank(),
    ];
  }

  List<Player> get players => _players;

  set players(List<Player> value) {
    _players = value;
  }
}
