import 'package:flutter/material.dart';
import 'package:redbacks/models/team.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/widgets/player_widget.dart';

import 'bench.dart';

class TeamWidget extends StatelessWidget {
  Team team;
  String mode;
  bool bench = false;

  TeamWidget(this.team, {this.mode, this.bench}) {
    List<TeamPlayer> players = this.team.players;
    r1Players.add(players[0]);
    r2Players.addAll([players[1], players[2]]);
    r3Players.addAll([players[3], players[4]]);
    if (!this.bench) {
      r2Players.add(players[5]);
    } else {
      benchPlayer = players[5];
    }
  }

  List<PlayerWidget> playerWidgets = [];
  List<TeamPlayer> r1Players = [];
  List<TeamPlayer> r2Players = [];
  List<TeamPlayer> r3Players = [];
  TeamPlayer benchPlayer;


  List<PlayerWidget> playersToWidgets(List<TeamPlayer> players) {
    List<PlayerWidget> widgets = [];

    players.forEach((p) {
      widgets.add(PlayerWidget.fromTeamPlayer(p, this.mode));
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilt team widg");
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          this.bench
              ? Bench(
                  player: (PlayerWidget.fromTeamPlayer(
                    this.benchPlayer,
                    this.mode,
                    benched: true,
                  )),
                )
              : Container(),
        ],
      ),
    );
  }
}
