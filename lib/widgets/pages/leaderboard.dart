import 'package:flutter/material.dart';
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
      alignment: Alignment.center,
      margin: EdgeInsets.all(15),
      height: double.maxFinite,
      width: MediaQuery.of(context).size.width,
      child: LeaderboardList(),
    );
  }
}
