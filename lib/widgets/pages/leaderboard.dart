import 'package:flutter/material.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/models/leaderboard_list_entry.dart';
import 'package:redbacks/widgets/leaderboard_list.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<LeaderboardListEntry> _entries = [];

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        color: Colors.white70.withAlpha(240),
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: LeaderboardList(),
      ),
    );
  }

  Widget LeaderboardListLEGACY() {
    _entries.sort((a, b) => b.totalPts.compareTo(a.totalPts));
    return Column(
      children: [
        ColumnHeadings(),
        Expanded(
          child: ListView.builder(
            itemCount: _entries.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                  margin: EdgeInsets.all(0.2),
                  child: ListTile(
                    leading: Text("${index + 1}"),
                    title: Text('${_entries[index].teamName}'),
                    subtitle: Text("${_entries[index].name}"),
                    trailing: Text("${_entries[index].totalPts}"),
                  ));
            },
          ),
        ),
      ],
    );
  }

  Widget ColumnHeadings() {
    return Card(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(0),
      child: ListTile(
        // contentPadding: EdgeInsets.all(0),
        dense: true,
        leading:
            Text("Pos", style: TextStyle(color: Colors.white, fontSize: 15)),
        title:
            Text("Name", style: TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Container(
          width: 150,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text("GW-Pts", style: TextStyle(color: Colors.white, fontSize: 15)),
            Text("Total", style: TextStyle(color: Colors.white, fontSize: 15))
          ]),
        ),
        tileColor: Theme.of(context).primaryColor.withAlpha(170),
      ),
    );
  }

  void _loadEntries() {
    setState(() {
      _entries = FirebaseCore().loadUserLeadeboard();
    });
  }
}
