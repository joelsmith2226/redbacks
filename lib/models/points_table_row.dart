class PointsTableRow {
  String position;
  String teamName;
  String played;
  String win;
  String draws;
  String losses;
  String goalsFor;
  String goalsAgainst;
  String goalDifference;
  String points;

  PointsTableRow(String fixture) {
    List<String> fields = fixture.split('\n');
    RegExp exp = RegExp(r"[0-9]+\.");
    if (fields.length < 10 || !exp.hasMatch(fields[1])) {
      return;
    }
    position = fields[1];
    teamName = fields[2].replaceAll(' ', '\n').trim();
    played = fields[3];
    win = fields[4];
    draws = fields[5];
    losses = fields[6];
    goalsFor = fields[7];
    goalsAgainst = fields[8];
    goalDifference = fields[9];
    points = fields[10];
  }

  void printPointsRow(){
    print("$position $teamName $played $win $draws $losses $goalsFor");
  }
}