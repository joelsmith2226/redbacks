import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/providers/gameweek.dart';
import 'package:redbacks/widgets/player/player_point_breakdown.dart';

class PlayerPointBreakdowns extends StatelessWidget {
  Player p;
  List<Gameweek> gws;

  PlayerPointBreakdowns(this.gws, this.p);

  @override
  Widget build(BuildContext context) {
    this.gws.sort((a, b) => b.id - a.id);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: gws.length,
          itemBuilder: (context, index) {
            return PlayerPointBreakdown(this.gws[index], this.p);
          }
      )
    );
  }
}
