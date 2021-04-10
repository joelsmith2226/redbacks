import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/models/team_player.dart';
import 'package:redbacks/widgets/player_list_tile.dart';

class PlayerList extends StatelessWidget {
  List<Player> players;
  TeamPlayer outgoingPlayer;

  PlayerList({this.players, this.outgoingPlayer});

  @override
  Widget build(BuildContext context) {
    this.players.sort((a, b) => a.position.compareTo(b.position));
    return Container(
      height: MediaQuery.of(context).size.height*0.6,
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: players.length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.all(0.2),
              child: PlayerListTile(
                player: players[index],
                outgoing: this.outgoingPlayer,
              ));
        },
      ),
    );
  }
}
