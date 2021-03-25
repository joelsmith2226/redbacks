import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/playerWidget.dart';

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  PlayerWidget p1 = PlayerWidget(Player.blank());
  PlayerWidget p2 = PlayerWidget(Player.blank());
  PlayerWidget p3 = PlayerWidget(Player.blank());
  PlayerWidget p4 = PlayerWidget(Player.blank());
  PlayerWidget p5 = PlayerWidget(Player.blank());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        children: [
          p1,
          Row(children: [p2, p3]),
          Row(children: [p4, p5]),
        ]
      )
    );
  }
}
