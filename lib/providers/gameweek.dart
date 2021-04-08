import 'package:flutter/material.dart';
import 'package:flutter_form_builder/src/form_builder.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/playerGameweek.dart';

class Gameweek extends ChangeNotifier {
  int _id;
  String _opposition;
  String _gameScore;
  List<PlayerGameweek> _playerGameweeks = [];
  int _currPlayerIndex = 0;

  Gameweek(List<Player> players) {
    for (int i = 0; i < players.length; i++) {
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

  void saveDataToGWObject(FormBuilderState currentState) {
    PlayerGameweek curr = this.playerGameweeks[this.currPlayerIndex];
    curr.position = ifValidReturn(currentState, POSITION, "DEF");
    curr.assists = int.parse(ifValidReturn(currentState, ASSISTS, "0"));
    curr.ownGoals = int.parse(ifValidReturn(currentState, OWNS, "0"));
    curr.penaltiesMissed = int.parse(ifValidReturn(currentState, PENS, "0"));
    curr.goals = int.parse(ifValidReturn(currentState, GOALS, "0"));
    curr.saves = int.parse(ifValidReturn(currentState, SAVES, "0"));
    curr.yellowCards = int.parse(ifValidReturn(currentState, YELLOW, "0"));
    curr.redCards = int.parse(ifValidReturn(currentState, RED, "0"));
    curr.bonus = int.parse(ifValidReturn(currentState, BONUS, "0"));
    setClean(currentState, curr);
    curr.saved = true;
    notifyListeners();
  }

  dynamic ifValidReturn(
      FormBuilderState currentState, String field, dynamic fallback) {
    return currentState.fields[field].value == null
        ? fallback
        : currentState.fields[field].value;
  }

  void setClean(FormBuilderState currentState, PlayerGameweek curr){
    // Set all cleans to false;
    curr.fullClean = false;
    curr.halfClean = false;
    curr.quarterClean = false;
    switch (currentState.fields[CLEANS].value){
      case NO_CLEAN:
        break;
      case QUARTER_CLEAN:
        curr.quarterClean = true;
        break;
      case HALF_CLEAN:
        curr.halfClean = true;
        break;
      case FULL_CLEAN:
        curr.fullClean = true;
        break;
    }
  }
}
