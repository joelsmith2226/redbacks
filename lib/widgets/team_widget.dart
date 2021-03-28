import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/player_widget.dart';

import 'bench.dart';

class TeamWidget extends StatefulWidget {
  Team team;
  String secondaryValueType;

  TeamWidget(this.team, this.secondaryValueType);

  @override
  _TeamWidgetState createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  List<PlayerWidget> players = [];

  @override
  void initState() {
    print(widget.team);
    String secondaryValue = widget.secondaryValueType == "points" ? "5" : "\$37.5m";
    players.add(PlayerWidget(Player.blank(), secondaryValue));
    players.add(PlayerWidget(Player.blank(), secondaryValue));
    players.add(PlayerWidget(Player.blank(), secondaryValue));
    Player captain = Player.blank();
    captain.rank = "C";
    Player vice = Player.blank();
    captain.rank = "V";
    players.add(PlayerWidget(captain, secondaryValue));
    players.add(PlayerWidget(vice, secondaryValue));
    players.add(PlayerWidget(Player.blank(), secondaryValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          players[0],
          Row(children: [players[1], players[2]], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
          Row(children: [players[3], players[4]], mainAxisAlignment: MainAxisAlignment.spaceAround),
          SizedBox(height: 15),
          Bench(player: Player.blank(), secondary: "5",),
        ]
      )
    );
  }
}
