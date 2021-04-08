import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:redbacks/models/player.dart';

class PlayerGameweek {
  String _id;
  String _position;
  int _goals = 0;
  int _assists = 0;
  int _saves = 0;
  bool _quarterClean = false;
  bool _halfClean = false;
  bool _fullClean = false;
  int _goalsConceded = 0;
  int _yellowCards = 0;
  int _redCards = 0;
  int _ownGoals = 0;
  int _penaltiesMissed = 0;
  int _bonus = 0;
  int _gwPts = 0;
  bool _saved = false;
  Player _player;
  final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();

  PlayerGameweek(Player p) {
    this.id = p.name;
    this.position = p.position;
    this.player = p;
  }

  int get bonus => _bonus;

  set bonus(int value) {
    _bonus = value;
  }

  int get penaltiesMissed => _penaltiesMissed;

  set penaltiesMissed(int value) {
    _penaltiesMissed = value;
  }

  int get ownGoals => _ownGoals;

  set ownGoals(int value) {
    _ownGoals = value;
  }

  int get redCards => _redCards;

  set redCards(int value) {
    _redCards = value;
  }

  int get yellowCards => _yellowCards;

  set yellowCards(int value) {
    _yellowCards = value;
  }

  int get goalsConceded => _goalsConceded;

  set goalsConceded(int value) {
    _goalsConceded = value;
  }

  bool get fullClean => _fullClean;

  set fullClean(bool value) {
    _fullClean = value;
  }

  bool get halfClean => _halfClean;

  set halfClean(bool value) {
    _halfClean = value;
  }

  bool get quarterClean => _quarterClean;

  set quarterClean(bool value) {
    _quarterClean = value;
  }

  int get saves => _saves;

  set saves(int value) {
    _saves = value;
  }

  int get assists => _assists;

  set assists(int value) {
    _assists = value;
  }

  int get goals => _goals;

  set goals(int value) {
    _goals = value;
  }

  String get position => _position;

  set position(String value) {
    _position = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get gwPts => _gwPts;

  set gwPts(int value) {
    _gwPts = value;
  }

  bool get saved => _saved;

  set saved(bool value) {
    _saved = value;
  }

  Player get player => _player;

  set player(Player value) {
    _player = value;
  }
}