import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/playerGameweek.dart';

class Gameweek extends ChangeNotifier {
  int _id;
  String _opposition;
  String _gameScore;
  List<PlayerGameweek> _playerGameweeks = [];
  int _currPlayerIndex = 0;

  Gameweek(List<Player> players){
    for (int i = 0; i < players.length; i++){
      this.playerGameweeks.add(PlayerGameweek(players[i]));
    }
  }

  List<PlayerGameweek> get playerGameweeks => _playerGameweeks;

  set playerGameweeks(List<PlayerGameweek> value) {
    _playerGameweeks = value;
  }

  String get gameScore => _gameScore;

  set gameScore(String value) {
    _gameScore = value;
  }

  String get opposition => _opposition;

  set opposition(String value) {
    _opposition = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get currPlayerIndex => _currPlayerIndex;

  set currPlayerIndex(int value) {
    _currPlayerIndex = value;
    notifyListeners();
  }
}