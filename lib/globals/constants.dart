import 'dart:ui';

import 'package:flutter/material.dart';

// THEMING //

Map<int, Color> colorSwatch = {
  50: Color.fromRGBO(160, 19, 0, .1),
  100: Color.fromRGBO(160, 19, 0, .2),
  200: Color.fromRGBO(160, 19, 0, .3),
  300: Color.fromRGBO(160, 19, 0, .4),
  400: Color.fromRGBO(160, 19, 0, .5),
  500: Color.fromRGBO(160, 19, 0, .6),
  600: Color.fromRGBO(160, 19, 0, .7),
  700: Color.fromRGBO(160, 19, 0, .8),
  800: Color.fromRGBO(160, 19, 0, .9),
  900: Color.fromRGBO(160, 19, 0, 1.0),
};

const Color DEFAULT_COLOR = Color(0xffa01300);
const int LIGHT_THEME = 0;
const int DARK_THEME = 1;

// LOGIN RESPONSE CODES
const int SUCCESS = 0;
const int EMAIL_ALREADY_REGISTERED = 1;
const int NO_USER_EXISTS = 2;
const int USER_LINKED_OTHER_COMPANY = 3;
const int ERROR = 4;




// MODES
const String CAPTAIN = "cap";
const String VICE = "vice";
const String POINTS = "points";
const String PRICE = "price";
const String TRANSFER = "transfers";
const String PICK = "pick";
const String SUB = "sub";
const String CAROUSEL = "carousel";
const int NUM_PLAYERS = 15;
const String PLAYERSTATS = "player-stats";
// ADMIN
const String OPPOSITION = "opposition";
const String APPEARANCE = "appearance";
const String SCORE = "score";
const String CONCEDED = "conceded";
const String HOME = "home";
const String AWAY = "away";
const String GAMEWEEK = "gw";
const String POSITION = "position";
const String GOALS = "goals";
const String ASSISTS = "assists";
const String SAVES = "saves";
const String CLEANS = "cleans";
const String YELLOW = "yellow";
const String RED = "red";
const String OWNS = "owns";
const String PENS = "pens";
const String BONUS = "bonus";
const String NO_CLEAN = "0";
const String QUARTER_CLEAN = "1/4";
const String HALF_CLEAN = "1/2";
const String FULL_CLEAN = "Full";

// Point System
const Map<String, Map<String, int>> POINT_SYSTEM = {
  "GKP": {
    GOALS: 10,
    ASSISTS: 5,
    SAVES: 1,
    YELLOW: -1,
    RED: -4,
    OWNS: -2,
    PENS: -2,
    BONUS: 1,
    NO_CLEAN: 0,
    QUARTER_CLEAN: 1,
    HALF_CLEAN: 2,
    FULL_CLEAN: 5,
    CONCEDED: -1,
    APPEARANCE: 2,
  },
  "DEF": {
    GOALS: 8,
    ASSISTS: 4,
    SAVES: 0,
    YELLOW: -1,
    RED: -4,
    OWNS: -2,
    PENS: -2,
    BONUS: 1,
    NO_CLEAN: 0,
    QUARTER_CLEAN: 0,
    HALF_CLEAN: 2,
    FULL_CLEAN: 5,
    CONCEDED: -1,
    APPEARANCE: 2,
  },
  "MID": {
    GOALS: 6,
    ASSISTS: 3,
    SAVES: 0,
    YELLOW: -1,
    RED: -4,
    OWNS: -2,
    PENS: -2,
    BONUS: 1,
    NO_CLEAN: 0,
    QUARTER_CLEAN: 0,
    HALF_CLEAN: 0,
    FULL_CLEAN: 1,
    CONCEDED: 0,
    APPEARANCE: 2,
  },
  "FWD": {
    GOALS: 4,
    ASSISTS: 2,
    SAVES: 0,
    YELLOW: -1,
    RED: -4,
    OWNS: -2,
    PENS: -2,
    BONUS: 1,
    NO_CLEAN: 0,
    QUARTER_CLEAN: 0,
    HALF_CLEAN: 0,
    FULL_CLEAN: 0,
    CONCEDED: 0,
    APPEARANCE: 2,
  },
};
const Map<String, String> POINT_LABELS = {
  GOALS: "Goals Scored",
  ASSISTS: "Assists",
  SAVES: "2x Saves Made",
  YELLOW: "Yellow Cards",
  RED: "Red Cards",
  OWNS: "Own Goals",
  PENS: "Pens Missed",
  BONUS: "Bonus",
  QUARTER_CLEAN: "1/4 Clean",
  HALF_CLEAN: "1/2 Clean",
  FULL_CLEAN: "Full Clean",
  CONCEDED: "Goals Conceded",
  APPEARANCE: "Appearance",
};

class OtherPointPageArgs {
  final String uid;
  final String name;
  final String teamName;
  final int currWeek;

  OtherPointPageArgs(this.uid, this.name, this.teamName, this.currWeek);
}

const int UNLIMITED = 100;
const String UNLIMITED_SYMBOL = '∞';

const String SEVERITY = 'severity';
const String MESSAGE = 'message';
const String PERCENT = 'percent';
