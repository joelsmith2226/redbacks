import 'package:flutter/material.dart';
import 'package:redbacks/models/player.dart';
import 'package:redbacks/widgets/player_list_tile.dart';

class PlayerList extends StatelessWidget {
  List<Player> players;

  PlayerList({this.players});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
                outgoing: false,
              ));
        },
      ),
    );
  }
}
