import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/widgets/player_widget.dart';

import 'bench.dart';

class TeamWidget extends StatefulWidget {
  Team team;
  String secondaryValueType;
  bool bench = false;

  TeamWidget(this.team, this.secondaryValueType, {this.bench});

  @override
  _TeamWidgetState createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  List<PlayerWidget> playerWidgets = [];
  List<Player> r1Players = [];
  List<Player> r2Players = [];
  List<Player> r3Players = [];

  @override
  void initState() {
    List<Player> players = widget.team.players;
    r1Players.add(players[0]);
    r2Players.addAll([players[1], players[2]]);
    r3Players.addAll([players[3], players[4]]);
    if (!widget.bench) {
      r2Players.add(players[5]);
    }
    super.initState();
  }

  List<PlayerWidget> playersToWidgets(List<Player> players) {
    List<PlayerWidget> widgets = [];

    players.forEach((p) {
      widgets.add(PlayerWidget(
          p,
          widget.secondaryValueType == "money"
              ? "${p.price}"
              : "${p.currPts}"));
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          Row(
            children: playersToWidgets(r1Players),
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(
            children: playersToWidgets(r2Players),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: playersToWidgets(r3Players),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          SizedBox(height: 15),
          widget.bench
              ? Bench(
                  player: (PlayerWidget(
                    Player.template(),
                    "benched",
                    benched: true,
                  )),
                )
              : Container(),
        ]));
  }
}
