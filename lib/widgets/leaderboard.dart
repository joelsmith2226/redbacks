import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20),
        color: Colors.white70.withAlpha(240),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LeaderboardList(),
      ),
    );
  }

  Widget LeaderboardList() {
    List<DummyEntries> entries = [
      DummyEntries("Jon Snow", "Ghost go woof", 28, 420),
      DummyEntries("Tyrion Lannister", "Mbappe is available", 55, 333),
      DummyEntries("Tyrone Mings", "Tings goes skrrrt", 34, 520),
      DummyEntries("Alex Oxlade-Chamberlain", "Little Mix it Up", 1, 102),
      DummyEntries("Cameron James", "I like chelsea", 100, 502),
      DummyEntries("Josh Cutcliffe", "I like spurs", 101, 503),
      DummyEntries("Tom David", "Mooy Caliente", 84, 511),
      DummyEntries("BJ Walkerden", "BJ KHALEED", 59, 503),
      DummyEntries("Cam Moss", "TWO TIMES IN A ROW?!", 21, 504),
      DummyEntries("Joel Smith", "Revenge of the Smith", 99, 506),
    ];

    entries.sort((a, b) => b.totalPts.compareTo(a.totalPts));

    return Column(
      children: [
        ColumnHeadings(),
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                  margin: EdgeInsets.all(0.2),
                  child: ListTile(
                    leading: Text("${index + 1}"),
                    title: Text('${entries[index].teamName}'),
                    subtitle: Text("${entries[index].name}"),
                    trailing: Text("${entries[index].totalPts}"),
                  ));
            },
          ),
        ),
      ],
    );
  }

  Widget ColumnHeadings() {
    return Card(
      color: Colors.black.withAlpha(250),
      margin: EdgeInsets.all(0),
      child: ListTile(
        // contentPadding: EdgeInsets.all(0),
        dense: true,
        leading:
            Text("Pos", style: TextStyle(color: Colors.white, fontSize: 15)),
        title:
            Text("Name", style: TextStyle(color: Colors.white, fontSize: 15)),
        trailing:
            Text("Pts", style: TextStyle(color: Colors.white, fontSize: 15)),
        tileColor: Theme.of(context).primaryColor.withAlpha(170),
      ),
    );
  }
}

class DummyEntries {
  String name;
  String teamName;
  int gwPts;
  int totalPts;

  DummyEntries(this.name, this.teamName, this.gwPts, this.totalPts);
}
