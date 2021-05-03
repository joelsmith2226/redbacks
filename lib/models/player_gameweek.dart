import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/point_breakdown.dart';

class PlayerGameweek {
  String _id;
  String _position;
  bool _appearance;
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
  PointBreakdown _pointBreakdown;

  final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();

  PlayerGameweek(Player p) {
    this.id = p.name;
    this.position = p.position;
    this.player = p;
    this.pointBreakdown = PointBreakdown();
  }

  PlayerGameweek.fromData(Map<String, dynamic> data, String name, Player p) {
    this.id = name;
    this.appearance = data["appearance"];
    this.position = data["position"];
    this.goals = data["goals"];
    this.assists = data["assists"];
    this.saves = data["saves"];
    this.goalsConceded = data["goals-conceded"];
    this.quarterClean = data["quarter-clean"];
    this.halfClean = data["half-clean"];
    this.fullClean = data["full-clean"];
    this.yellowCards = data["yellow"];
    this.redCards = data["red"];
    this.ownGoals = data["owns"];
    this.penaltiesMissed = data["pens"];
    this.bonus = data["bonus"];
    if (data["gw-pts"] == null) {
      this.calculatePoints();
    } else {
      this.gwPts = data["gw-pts"];
    }
    this.saved = true;
    this.player = p;
    this.pointBreakdown = PointBreakdown.fromMap(data["point-breakdown"]);
  }

  void calculatePoints() {
    this.gwPts = 0;
    if (this.appearance) {
      gwPts += 2;
      gwPts += this.goals * POINT_SYSTEM[position][GOALS];
      gwPts += this.assists * POINT_SYSTEM[position][ASSISTS];
      gwPts += this.saves * POINT_SYSTEM[position][SAVES];
      gwPts += this.quarterClean ? POINT_SYSTEM[position][QUARTER_CLEAN] : 0;
      gwPts += this.halfClean ? POINT_SYSTEM[position][HALF_CLEAN] : 0;
      gwPts += this.fullClean ? POINT_SYSTEM[position][FULL_CLEAN] : 0;
      gwPts += this.goalsConceded * POINT_SYSTEM[position][CONCEDED];
      gwPts += this.yellowCards * POINT_SYSTEM[position][YELLOW];
      gwPts += this.redCards * POINT_SYSTEM[position][RED];
      gwPts += this.ownGoals * POINT_SYSTEM[position][OWNS];
      gwPts += this.penaltiesMissed * POINT_SYSTEM[position][PENS];
      gwPts += this.bonus * POINT_SYSTEM[position][BONUS];
    }
    // Clear existing point breakdown first then readd
    this.pointBreakdown.empty();
    generatePointBreakdown();
    print(this.pointBreakdown.toMap());
  }

  void generatePointBreakdown() {
    if (this.appearance) {
      _addPointBreakdownBool(APPEARANCE, this.appearance);
      _addPointBreakdown(GOALS, this.goals);
      _addPointBreakdown(ASSISTS, this.assists);
      _addPointBreakdown(SAVES, this.saves);
      _addPointBreakdownBool(QUARTER_CLEAN, this.quarterClean);
      _addPointBreakdownBool(HALF_CLEAN, this.halfClean);
      _addPointBreakdownBool(FULL_CLEAN, this.fullClean);
      _addPointBreakdown(CONCEDED, this.goalsConceded);
      _addPointBreakdown(YELLOW, this.yellowCards);
      _addPointBreakdown(RED, this.redCards);
      _addPointBreakdown(OWNS, this.ownGoals);
      _addPointBreakdown(PENS, this.penaltiesMissed);
      _addPointBreakdown(BONUS, this.bonus);
    }
  }

  void _addPointBreakdown(String key, int value) {
      if (value != 0) {
      this.pointBreakdown.addPointBreakdownRow(
          key, value, POINT_SYSTEM[position][key] * value);
    }
  }

  void _addPointBreakdownBool(String key, bool value) {
    if (value) {
      this.pointBreakdown.addPointBreakdownRow(
          key, 1, POINT_SYSTEM[position][key]);
    }
  }

  bool get appearance => _appearance;

  set appearance(bool value) {
    _appearance = value;
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

  PointBreakdown get pointBreakdown => _pointBreakdown;

  set pointBreakdown(PointBreakdown value) {
    _pointBreakdown = value;
  }
}
