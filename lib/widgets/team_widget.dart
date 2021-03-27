import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/player_widget.dart';

class TeamWidget extends StatefulWidget {
  Team team;

  TeamWidget(this.team);

  @override
  _TeamWidgetState createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  List<PlayerWidget> players = [];

  @override
  void initState() {
    print(widget.team);

    players.add(PlayerWidget(Player.blank()));
    players.add(PlayerWidget(Player.blank()));
    players.add(PlayerWidget(Player.blank()));
    players.add(PlayerWidget(Player.blank()));
    players.add(PlayerWidget(Player.blank()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          players[0],
          Row(children: [players[1], players[2]], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          SizedBox(height:30),
          Row(children: [players[3], players[4]], mainAxisAlignment: MainAxisAlignment.spaceAround),
        ]
      )
    );
  }
}
