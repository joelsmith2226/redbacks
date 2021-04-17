import 'package:redbacks/providers/gameweek.dart';

class Player {
  String _uid = ""; // Hopefully will never not be set from DB.. or its a team version player... :|
  String _name;
  double _price;
  int _transferredIn = 0;
  int _transferredOut = 0;
  int _totalPts = 0;
  int _currPts = 0;
  String _rank = "";
  String _position;
  String _flagged = "";
  bool _removed = false;
  bool _inConsideration = false;
  String _pic = "";
  List<Gameweek> _gwResults = [];

  Player.blank() {
    this._name = "";
    this._price = 0;
    this._transferredIn = 0;
    this._transferredOut = 0;
    this._totalPts = 0;
    this._currPts = 0;
    this._rank = "";
    this._position = "";
    this._flagged = "";
  }

  Player.template() {
    this._name = "Cameron James";
    this._price = 37.5;
    this._transferredIn = 0;
    this._transferredOut = 0;
    this._totalPts = 0;
    this._currPts = 5;
    this._rank = "";
    this._position = "FWD";
    this._flagged = "";
  }

  Player.fromData(Map<String, dynamic> data, {String uid = ""}) {
    this.uid = uid;
    this.name = data["name"];
    this.price = data["price"];
    this.transferredIn = data["transferredIn"];
    this.transferredOut = data["transferredOut"];
    this.totalPts = data["totalPts"];
    this.currPts = data["gwPts"];
    this.rank = "";
    this.position = data["position"];
    this.flagged = data["flagged"];
    this.pic = data["picture"];
  }

  Map<String, dynamic> toMap(){
    return {
      "Name" : this.name,
      "Pos" : this.position,
      "Price": this.price,
      "GW Pts": this.currPts,
      "Total Pts": this.totalPts,
      "In": this.transferredIn,
      "Out": this.transferredOut,
    };
  }

  Player.initial(String name, double value, String position) {
    this._name = name;
    this._price = value;
    this._position = position;
  }

  String getLastName() {
    if (this.name == "") {
      return "?";
    }
    return this._name.split(' ')[1];
  }

  String get rank => _rank;

  set rank(String value) {
    _rank = value;
  }

  int get currPts => _currPts;

  set currPts(int value) {
    _currPts = value;
  }

  int get totalPts => _totalPts;

  set totalPts(int value) {
    _totalPts = value;
  }

  int get transferredOut => _transferredOut;

  set transferredOut(int value) {
    _transferredOut = value;
  }

  int get transferredIn => _transferredIn;

  set transferredIn(int value) {
    _transferredIn = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get flagged => _flagged;

  set flagged(String value) {
    _flagged = value;
  }

  String get position => _position;

  set position(String value) {
    _position = value;
  }

  bool get removed => _removed;

  set removed(bool value) {
    _removed = value;
  }

  String get pic => _pic;

  set pic(String value) {
    _pic = value;
  }

  List<Gameweek> get gwResults => _gwResults;

  set gwResults(List<Gameweek> value) {
    _gwResults = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  bool get inConsideration => _inConsideration;

  set inConsideration(bool value) {
    _inConsideration = value;
  }
}
