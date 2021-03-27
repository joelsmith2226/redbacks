class Player {
  String _name;
  double _value;
  int _transferredIn;
  int _transferredOut;
  int _totalPts;
  int _currPts;
  String _rank;

  Player.blank(){
    this._name = "Cameron James";
    this._value = 37.5;
    this._transferredIn = 0;
    this._transferredOut = 0;
    this._totalPts = 0;
    this._currPts = 5;
    this._rank = "";
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

  double get value => _value;

  set value(double value) {
    _value = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}