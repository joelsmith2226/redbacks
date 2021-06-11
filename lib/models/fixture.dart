class Fixture {
  String date;
  String round;
  String home;
  String away;
  String time;
  String field;

  Fixture(this.date, this.round, this.home, this.away, this.time, this.field);

  Fixture.fromString(String fixture) {
    List<String> fields = fixture.split('\n');
    date = fields[0].split('-').sublist(0, 2).join(' ');
    round = fields[2];
    home = fields[3].replaceAll(' ', '\n').trim();
    away = fields[4].replaceAll(' ', '\n').trim();
    time = fields[6];
    field = fields[5].replaceAll(' ', '\n').trim();
  }
}