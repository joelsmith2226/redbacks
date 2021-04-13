class PointBreakdown{
  List<PointBreakdownRow> _pointBreakdownRows = [];
  PointBreakdown();

  PointBreakdown.fromMap(Map<String, dynamic> map){
    map.forEach((key, value) {
      pointBreakdownRows.add(PointBreakdownRow(key, value[0], value[1]));
    });
  }

  List<PointBreakdownRow> get pointBreakdownRows => _pointBreakdownRows;

  set pointBreakdownRows(List<PointBreakdownRow> value) {
    _pointBreakdownRows = value;
  }

  void addPointBreakdownRow(String category, int value, int points){
    this.pointBreakdownRows.add(PointBreakdownRow(category, value, points));
  }

  Map<String, List<int>> toMap(){
    Map<String, List<int>> pointBreakdownMap = {};
    this.pointBreakdownRows.forEach((row) {
      pointBreakdownMap[row.category] = [row._value, row.points];
    });
    return pointBreakdownMap;
  }
}

class PointBreakdownRow {
  String _category;
  int _points;
  int _value;

  PointBreakdownRow(this._category, this._value, this._points);

  int get points => _points;

  set points(int value) {
    _points = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  int get value => _value;

  set value(int value) {
    _value = value;
  }
}