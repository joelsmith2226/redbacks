class Player {
  String _name;
  double _price;
  int _transferredIn = 0;
  int _transferredOut = 0;
  int _totalPts = 0;
  int _currPts = 0;
  String _rank = "";
  String _position;
  String _flagged = "";

  Player.blank(){
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

  Player.initial(String name, double value, String position){
    this._name = name;
    this._price = value;
    this._position = position;
  }

  String getLastName(){
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


}