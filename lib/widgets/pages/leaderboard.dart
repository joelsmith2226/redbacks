import 'package:flutter/material.dart';
import 'package:redbacks/globals/rFirebase/firebaseCore.dart';
import 'package:redbacks/models/leaderboard_list_entry.dart';
import 'package:redbacks/widgets/leaderboard_list.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {

  @override
  void initState() {
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
}
