import 'package:redbacks/models/player.dart';
import 'package:redbacks/providers/gameweek.dart';

class TeamPlayer {
  // Loaded from DB
  String _name = "";
  double _boughtPrice = 0.0;
  String _rank = "";
  int _index;

  // Loaded Programmatically
  String _uid = "";
  double _currPrice = 0.0;
  int _totalPts = 0;
  int _currPts = 0;
  String _position;
  String _flagged = "";
  bool _removed = false;
  String _pic = "";
  List<Gameweek> _gwResults = [];
  int _transferredIn = 0;
  int _transferredOut = 0;

  TeamPlayer.blank(int index) {
    this.name = "";
    this.boughtPrice = 0.0;
    this.index = index;
  }

  TeamPlayer.fromData(Map<String, dynamic> data, Player p, int index) {
    this.name = data["name"];
    this.boughtPrice = data["bought-price"];
    this.rank = data["rank"];
    this.index = index;

    this.loadPlayerModelFields(p);
  }

  TeamPlayer.fromPlayer(Player player, int index) {
    this.name = player.name;
    this.boughtPrice = player.price;
    this.rank = "";
    this.index = index;

    this.loadPlayerModelFields(player);
  }

  void loadPlayerModelFields(Player p) {
    this.uid = p.uid;
    this.currPrice = p.price;
    this.totalPts = p.totalPts;
    this.currPts = p.currPts;
    this.position = p.position;
    this.flagged = p.flagged;
    this.removed = p.removed;
    this.pic = p.pic;
    this.gwResults = p.gwResults;
    this.transferredOut = p.transferredOut;
    this.transferredIn = p.transferredIn;
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

  double get boughtPrice => _boughtPrice;

  set boughtPrice(double value) {
    _boughtPrice = value;
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

  double get currPrice => _currPrice;

  set currPrice(double value) {
    _currPrice = value;
  }

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  Player playerFromTeamPlayer(List<Player> playerDB) {
    return playerDB.firstWhere((p) => p.name == this.name,
        orElse: () => Player.blank());
  }
}
