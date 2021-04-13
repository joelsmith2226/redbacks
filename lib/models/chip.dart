class Chip {
  String _name;
  bool _available;
  bool _active;

  Chip(this._name, this._available, this._active);

  Chip.fromMap(Map<String, dynamic> data){
    this.name = data["name"];
    this.available = data["available"];
    this.active = data["active"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {};
    map["name"] = this.name;
    map["available"] = this.available;
    map["active"] = this.active;
  }

  bool get active => _active;

  set active(bool value) {
    _active = value;
  }

  bool get available => _available;

  set available(bool value) {
    _available = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}