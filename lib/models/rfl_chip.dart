class RFLChip {
  String _name;
  bool _available;
  bool _active;

  RFLChip(this._name, this._available, this._active);

  RFLChip.fromMap(Map<String, dynamic> data){
    this.name = data["name"];
    this.available = data["available"];
    this.active = data["active"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {};
    map["name"] = this.name;
    map["available"] = this.available;
    map["active"] = this.active;
    return map;
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