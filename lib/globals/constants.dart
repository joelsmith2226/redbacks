import 'dart:ui';

import 'package:redbacks/views/admin.dart';

Map<int, Color> colorSwatch =
{
  50:Color.fromRGBO(160,19,0, .1),
  100:Color.fromRGBO(160,19,0,.2),
  200:Color.fromRGBO(160,19,0, .3),
  300:Color.fromRGBO(160,19,0, .4),
  400:Color.fromRGBO(160,19,0, .5),
  500:Color.fromRGBO(160,19,0, .6),
  600:Color.fromRGBO(160,19,0, .7),
  700:Color.fromRGBO(160,19,0,.8),
  800:Color.fromRGBO(160,19,0, .9),
  900:Color.fromRGBO(160,19,0, 1),
};

const List<String> admins = ["joel.smith2226@gmail.com"];

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

// ADMIN
const String OPPOSITION = "opposition";
const String SCORE = "score";
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
